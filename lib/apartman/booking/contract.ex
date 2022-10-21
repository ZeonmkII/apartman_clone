defmodule Apartman.Booking.Contract do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Booking.MonthlyBooking
  alias Apartman.Tenant.MonthlyRent
  alias Apartman.Tenant
  alias Apartman.Facility.Room
  alias Apartman.Invoice.MonthlyInvoice
  alias Apartman.Receipt.ContractFee

  alias Apartman.Booking.Relationship.{
    SignContract,
    CreateReceipt,
    HasMonthlyInvoice,
    OccupyMonthly
  }

  node "Contract" do
    property(:contractId, :string)
    property(:dateSigned, :date)
    property(:checkIn, :date)
    property(:checkOut, :date)
    property(:roomNumber, :string)
    property(:rentFees, :string)
    property(:serviceFees, :string)
    property(:durationMonth, :integer)
    property(:durationDay, :integer)
    property(:deposit, :string)
    property(:advancePayment, :string)
    property(:keycardFees, :string)
    property(:keycardNumber, :string)
    property(:otherLabels, :string)
    property(:otherFees, :string)
    property(:meterWater, :float)
    property(:meterElectric, :float)
    property(:remarks, :string)

    incoming_relationship(
      "WALKIN_MONTHLY",
      MonthlyRent,
      :walkin_by,
      Tenant.Relationship.SignContract,
      cardinality: :one
    )

    incoming_relationship(
      "SIGN_CONTRACT",
      MonthlyBooking,
      :signed_by,
      SignContract,
      cardinality: :one
    )

    outgoing_relationship(
      "OCCUPY_MONTHLY",
      Room,
      :use,
      OccupyMonthly,
      cardinality: :one
    )

    outgoing_relationship(
      "CREATE_MONTHLY_INVOICE",
      MonthlyInvoice,
      :has_invoice,
      HasMonthlyInvoice,
      cardinality: :many
    )

    outgoing_relationship(
      "CREATE_CONTRACT_RECEIPT",
      ContractFee,
      :creates_contract_receipt,
      CreateReceipt,
      cardinality: :one
    )
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [
      :uuid,
      :contractId,
      :dateSigned,
      :checkIn,
      :checkOut,
      :roomNumber,
      :rentFees,
      :serviceFees,
      :durationMonth,
      :durationDay,
      :deposit,
      :advancePayment,
      :keycardFees,
      :keycardNumber,
      :otherLabels,
      :otherFees,
      :meterWater,
      :meterElectric,
      :remarks
    ])
    |> validate_required([
      :dateSigned,
      :checkIn,
      :checkOut,
      :roomNumber,
      :rentFees,
      :deposit,
      :advancePayment,
      :keycardFees,
      :keycardNumber,
      :meterWater,
      :meterElectric
    ])
    |> add_duration()
    |> add_contract_id()
  end

  defp add_duration(changeset) do
    checkIn = get_field(changeset, :checkIn)
    checkOut = get_field(changeset, :checkOut)
    total = Date.diff(checkOut, checkIn)

    # How many FULL months, that customer stayed (stay less than a month -> zero)
    # *** @TODO fix the logic; to cover months with 31 days ***
    months = div(total, 30)
    changeset = put_change(changeset, :durationMonth, months)

    # Home many remainder days (if customer left at 1st -> zero)
    # example: customer left at 14th May, then days_remain = 13  (14 - 1)
    firstOfMonth = %{checkOut | day: 1}
    days = Date.diff(checkOut, firstOfMonth)
    put_change(changeset, :durationDay, days)
  end

  defp add_contract_id(changeset) do
    id = get_field(changeset, :contractId)

    if is_nil(id) do
      {:ok, now} = DateTime.now("Asia/Bangkok")
      contractId = DateTime.to_iso8601(DateTime.truncate(now, :second), :basic)
      put_change(changeset, :contractId, contractId)
    else
      changeset
    end
  end
end

defmodule Apartman.Booking.MonthlyBooking do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Tenant
  alias Apartman.Tenant.MonthlyRent
  alias Apartman.Facility.Room
  alias Apartman.Invoice.BookingFee
  alias Apartman.Booking.Contract
  alias Apartman.Booking.Relationship.{SignContract, ReserveMonthly, HasMonthlyBookingFee}

  node "MonthlyBooking" do
    property(:bookingId, :string)
    property(:checkIn, :date)
    property(:checkOut, :date)
    property(:durationMonth, :integer)
    property(:durationDay, :integer)
    property(:remarks, :string)
    property(:rentFees, :string)
    property(:serviceFees, :string)
    property(:deposit, :string)
    property(:advancePayment, :string)
    property(:keycardFees, :string)
    property(:otherLabels, :string)
    property(:otherFees, :string)
    property(:remaining, :string)
    property(:total, :string)

    incoming_relationship(
      "BOOK_MONTHLY",
      MonthlyRent,
      :reserved_by,
      Tenant.Relationship.ReserveMonthly,
      cardinality: :one
    )

    outgoing_relationship(
      "SIGN_CONTRACT",
      Contract,
      :signs_contract,
      SignContract,
      cardinality: :one
    )

    outgoing_relationship(
      "BOOK_ROOM_MONTHLY",
      Room,
      :book_room,
      ReserveMonthly,
      cardinality: :one
    )

    outgoing_relationship(
      "HAS_MONTHLY_BOOKING_FEES",
      BookingFee,
      :has_booking_fees,
      HasMonthlyBookingFee,
      cardinality: :one
    )
  end

  @doc false
  def changeset(monthly_booking, attrs) do
    monthly_booking
    |> cast(attrs, [
      :uuid,
      :bookingId,
      :checkIn,
      :checkOut,
      :durationDay,
      :durationMonth,
      :remarks,
      :rentFees,
      :serviceFees,
      :deposit,
      :advancePayment,
      :keycardFees,
      :otherLabels,
      :otherFees,
      :remaining,
      :total
    ])
    |> validate_required([:checkIn, :checkOut, :rentFees, :deposit, :advancePayment, :keycardFees])
    |> add_duration()
    |> add_booking_id()
  end

  defp add_duration(changeset) do
    checkIn = get_field(changeset, :checkIn)
    checkOut = get_field(changeset, :checkOut)
    total = Date.diff(checkOut, checkIn)

    # How many FULL months, that customer stayed (stay less than a month -> zero)
    # ! TODO fix the logic; to cover months with 31 days
    months = div(total, 30)
    changeset = put_change(changeset, :durationMonth, months)

    # Home many remainder days (if customer left at 1st -> zero)
    # example: customer left at 14th May, then days_remain = 13  (14 - 1)
    firstOfMonth = %{checkOut | day: 1}
    days = Date.diff(checkOut, firstOfMonth)
    put_change(changeset, :durationDay, days)
  end

  defp add_booking_id(changeset) do
    booking_id = get_field(changeset, :bookingId)

    if is_nil(booking_id) do
      {:ok, now} = DateTime.now("Asia/Bangkok")
      bookingId = DateTime.to_iso8601(DateTime.truncate(now, :second), :basic)
      put_change(changeset, :bookingId, bookingId)
    else
      changeset
    end
  end
end

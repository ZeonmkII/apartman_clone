defmodule Apartman.Invoice.MonthlyInvoice do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Booking.Contract
  alias Apartman.Booking.Relationship.HasMonthlyInvoice

  node "MonthlyInvoice" do
    property(:billCycle, :date)
    property(:advancePayment, :string)
    property(:waterStart, :string)
    property(:waterEnd, :string)
    property(:waterUnit, :string)
    property(:electricStart, :string)
    property(:electricEnd, :string)
    property(:otherLabels, :string)
    property(:otherFees, :string)

    incoming_relationship(
      "CREATE_MONTHLY_INVOICE",
      Contract,
      :created_by,
      HasMonthlyInvoice,
      cardinality: :one
    )
  end

  @doc false
  def changeset(monthly_invoice, attrs) do
    monthly_invoice
    |> cast(attrs, [
      :uuid,
      :billCycle,
      :advancePayment,
      :waterStart,
      :waterEnd,
      :waterUnit,
      :electricStart,
      :electricEnd,
      :otherLabels,
      :otherFees
    ])
    |> validate_required([
      :billCycle,
      :advancePayment,
      :waterStart,
      :waterEnd,
      :waterUnit,
      :electricStart,
      :electricEnd
    ])
  end
end

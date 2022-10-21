defmodule Apartman.Invoice.DailyInvoice do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Booking.Checkin
  alias Apartman.Booking.Relationship.HasDailyInvoice

  node "DailyInvoice" do
    property(:deposit, :string)
    property(:roomFees, :string)
    property(:otherLabels, :string)
    property(:otherFees, :string)
    property(:remaining, :string)
    property(:total, :string)

    incoming_relationship(
      "CREATE_DAILY_INVOICE",
      Checkin,
      :created_by,
      HasDailyInvoice,
      cardinality: :one
    )
  end

  @doc false
  def changeset(daily_invoice, attrs) do
    daily_invoice
    |> cast(attrs, [:uuid, :deposit, :remaining, :roomFees, :otherLabels, :otherFees, :total])
    |> validate_required([:deposit])
    |> calculate_remainder()
  end

  defp calculate_remainder(changeset) do
    total = get_field(changeset, :total) |> String.trim() |> String.to_float()
    deposit = get_field(changeset, :deposit) |> String.trim() |> String.to_float()
    remainder = total - deposit
    put_change(changeset, :remaining, Float.to_string(remainder))
  end
end

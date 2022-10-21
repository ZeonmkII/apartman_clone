defmodule Apartman.Booking.Relationship.HasMonthlyInvoice do
  use Seraph.Schema.Relationship
  import Seraph.Changeset

  @cardinality [incoming: :one, outgoing: :many]

  relationship "CREATE_MONTHLY_INVOICE" do
    start_node(Apartman.Booking.Contract)
    end_node(Apartman.Invoice.MonthlyInvoice)

    property(:timestamp, :naive_datetime)
  end

  def changeset(wrote, params) do
    wrote
    |> cast(params, [:start_node, :end_node, :timestamp])
    |> add_timestamp()
  end

  defp add_timestamp(changeset) do
    {:ok, now} = DateTime.now("Asia/Bangkok")
    put_change(changeset, :timestamp, now)
  end
end

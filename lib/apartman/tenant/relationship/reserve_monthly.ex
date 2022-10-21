defmodule Apartman.Tenant.Relationship.ReserveMonthly do
  use Seraph.Schema.Relationship
  import Seraph.Changeset

  @cardinality [incoming: :one, outgoing: :one]

  relationship "BOOK_MONTHLY" do
    start_node(Apartman.Tenant.MonthlyRent)
    end_node(Apartman.Booking.MonthlyBooking)

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

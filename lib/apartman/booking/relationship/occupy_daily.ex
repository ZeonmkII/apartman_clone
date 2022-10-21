defmodule Apartman.Booking.Relationship.OccupyDaily do
  use Seraph.Schema.Relationship
  import Seraph.Changeset

  @cardinality [incoming: :one, outgoing: :one]

  relationship "OCCUPY_DAILY" do
    start_node(Apartman.Booking.Checkin)
    end_node(Apartman.Facility.Room)

    property(:timestamp, :naive_datetime)
    property(:dateFirst, :date)
    property(:dateLast, :date)
  end

  def changeset(wrote, params) do
    wrote
    |> cast(params, [:start_node, :end_node, :timestamp, :dateFirst, :dateLast])
    |> validate_required([:dateFirst, :dateLast])
    |> add_timestamp()
  end

  defp add_timestamp(changeset) do
    {:ok, now} = DateTime.now("Asia/Bangkok")
    put_change(changeset, :timestamp, now)
  end
end

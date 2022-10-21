defmodule Apartman.Booking.Relationship.ReserveDaily do
  use Seraph.Schema.Relationship
  import Seraph.Changeset

  @cardinality [incoming: :one, outgoing: :one]

  relationship "BOOK_ROOM_DAILY" do
    start_node(Apartman.Booking.DailyBooking)
    end_node(Apartman.Facility.Room)

    property(:timestamp, :naive_datetime)
    property(:date_first, :date)
    property(:date_last, :date)
  end

  def changeset(wrote, params) do
    wrote
    |> cast(params, [:start_node, :end_node, :timestamp, :date_first, :date_last])
    |> validate_required([:date_first, :date_last])
    |> add_timestamp()
  end

  defp add_timestamp(changeset) do
    {:ok, now} = DateTime.now("Asia/Bangkok")
    put_change(changeset, :timestamp, now)
  end
end

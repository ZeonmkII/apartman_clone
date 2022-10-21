defmodule Apartman.Facility.Room do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Booking.{DailyBooking, MonthlyBooking, Checkin, Contract}
  alias Apartman.Booking.Relationship.{ReserveDaily, ReserveMonthly, OccupyDaily, OccupyMonthly}
  alias Apartman.Facility.Floor
  alias Apartman.Facility.Relationship.HasRoom

  node "Room" do
    property(:number, :string)
    property(:bBooked, :boolean, default: false)
    property(:bOccupied, :boolean, default: false)

    incoming_relationship(
      "HAS_ROOM",
      Floor,
      :is_on,
      HasRoom,
      cardinality: :one
    )

    incoming_relationship(
      "BOOK_ROOM_DAILY",
      DailyBooking,
      :booked_daily_by,
      ReserveDaily,
      cardinality: :one
    )

    incoming_relationship(
      "BOOK_ROOM_MONTHLY",
      MonthlyBooking,
      :booked_monthly_by,
      ReserveMonthly,
      cardinality: :one
    )

    incoming_relationship(
      "OCCUPY_DAILY",
      Checkin,
      :use_daily_by,
      OccupyDaily,
      cardinality: :one
    )

    incoming_relationship(
      "OCCUPY_MONTHLY",
      Contract,
      :use_monthly_by,
      OccupyMonthly,
      cardinality: :one
    )
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:uuid, :number, :bBooked, :bOccupied])
    |> validate_required([:number])
  end
end

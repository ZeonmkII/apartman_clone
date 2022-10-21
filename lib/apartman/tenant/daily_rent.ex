defmodule Apartman.Tenant.DailyRent do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Tenant.Customer
  alias Apartman.Tenant.Relationship.{RentDaily, ReserveDaily, SignCheckin}
  alias Apartman.Booking.{DailyBooking, Checkin}

  node "DailyRent" do
    property(:bCurrent, :boolean, default: false)

    incoming_relationship("RENT_DAILY", Customer, :user, RentDaily, cardinality: :one)

    outgoing_relationship("BOOK_DAILY", DailyBooking, :reserve_booking, ReserveDaily,
      cardinality: :one
    )

    outgoing_relationship("WALKIN_DAILY", Checkin, :walkin, SignCheckin, cardinality: :one)
  end

  @doc false
  def changeset(daily_rent, attrs) do
    daily_rent
    |> cast(attrs, [:uuid, :bCurrent])
  end
end

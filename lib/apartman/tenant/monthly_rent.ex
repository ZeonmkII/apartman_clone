defmodule Apartman.Tenant.MonthlyRent do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Tenant.Customer
  alias Apartman.Tenant.Relationship.{RentMonthly, ReserveMonthly, SignContract}
  alias Apartman.Booking.{MonthlyBooking, Contract}

  node "MonthlyRent" do
    property(:bCurrent, :boolean, default: false)
    property(:bTenant, :boolean, default: false)
    property(:bContract, :boolean, default: false)

    incoming_relationship("RENT_MONTHLY", Customer, :user, RentMonthly, cardinality: :one)

    outgoing_relationship(
      "BOOK_MONTHLY",
      MonthlyBooking,
      :reserve_booking,
      ReserveMonthly,
      cardinality: :one
    )

    outgoing_relationship("WALKIN_MONTHLY", Contract, :walkin, SignContract, cardinality: :one)
  end

  @doc false
  def changeset(monthly_rent, attrs) do
    monthly_rent
    |> cast(attrs, [:uuid, :bCurrent, :bTenant, :bContract])
  end
end

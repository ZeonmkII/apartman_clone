defmodule Apartman.Booking.Checkin do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Tenant
  alias Apartman.Tenant.DailyRent
  alias Apartman.Booking.Relationship.{SignCheckin, OccupyDaily, HasDailyInvoice}
  alias Apartman.Booking.DailyBooking
  alias Apartman.Facility.Room
  alias Apartman.Invoice.DailyInvoice

  node "Checkin" do
    property(:checkIn, :date)
    property(:checkOut, :date)
    property(:timeIn, :time)
    property(:timeOut, :time)
    property(:durationDay, :integer)
    property(:roomNumber, :string)
    property(:deposit, :string)
    property(:from, :string)
    property(:to, :string)
    property(:remarks, :string)

    incoming_relationship(
      "WALKIN_DAILY",
      DailyRent,
      :walkin_by,
      Tenant.Relationship.SignCheckin,
      cardinality: :one
    )

    incoming_relationship(
      "SIGN_CHECKIN",
      DailyBooking,
      :signed_by,
      SignCheckin,
      cardinality: :one
    )

    outgoing_relationship("OCCUPY_DAILY", Room, :use, OccupyDaily, cardinality: :one)

    outgoing_relationship(
      "CREATE_DAILY_INVOICE",
      DailyInvoice,
      :has_invoice,
      HasDailyInvoice,
      cardinality: :one
    )
  end

  @doc false
  def changeset(checkin, attrs) do
    checkin
    |> cast(attrs, [
      :uuid,
      :checkIn,
      :checkOut,
      :timeIn,
      :timeOut,
      :durationDay,
      :roomNumber,
      :deposit,
      :from,
      :to,
      :remarks
    ])
    |> validate_required([
      :checkIn,
      :checkOut,
      :timeIn,
      :roomNumber,
      :from,
      :to
    ])
    |> add_duration()
  end

  defp add_duration(changeset) do
    checkIn = get_field(changeset, :checkIn)
    checkOut = get_field(changeset, :checkOut)
    put_change(changeset, :durationDay, Date.diff(checkOut, checkIn))
  end
end

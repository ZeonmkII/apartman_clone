defmodule Apartman.Booking.DailyBooking do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Tenant
  alias Apartman.Tenant.DailyRent
  alias Apartman.Booking.Checkin
  alias Apartman.Facility.Room
  alias Apartman.Invoice.BookingFee
  alias Apartman.Booking.Relationship.{SignCheckin, ReserveDaily, HasDailyBookingFee}

  node "DailyBooking" do
    property(:bookingId, :string)
    property(:checkIn, :date)
    property(:checkOut, :date)
    property(:durationDay, :integer)
    property(:remarks, :string)

    incoming_relationship(
      "BOOK_DAILY",
      DailyRent,
      :reserved_by,
      Tenant.Relationship.ReserveDaily,
      cardinality: :one
    )

    outgoing_relationship(
      "SIGN_CHECKIN",
      Checkin,
      :signs_checkin,
      SignCheckin,
      cardinality: :one
    )

    outgoing_relationship(
      "BOOK_ROOM_DAILY",
      Room,
      :book_room,
      ReserveDaily,
      cardinality: :one
    )

    outgoing_relationship(
      "HAS_DAILY_BOOKING_FEES",
      BookingFee,
      :has_booking_fees,
      HasDailyBookingFee,
      cardinality: :one
    )
  end

  @doc false
  def changeset(daily_booking, attrs) do
    daily_booking
    |> cast(attrs, [:uuid, :bookingId, :checkIn, :checkOut, :durationDay, :remarks])
    |> validate_required([:checkIn, :checkOut])
    |> add_duration()
    |> add_booking_id()
  end

  defp add_duration(changeset) do
    checkIn = get_field(changeset, :checkIn)
    checkOut = get_field(changeset, :checkOut)
    put_change(changeset, :durationDay, Date.diff(checkOut, checkIn))
  end

  defp add_booking_id(changeset) do
    booking_id = get_field(changeset, :bookingId)

    if is_nil(booking_id) do
      {:ok, now} = DateTime.now("Asia/Bangkok")
      bookingId = DateTime.to_iso8601(DateTime.truncate(now, :second), :basic)
      put_change(changeset, :bookingId, bookingId)
    else
      changeset
    end
  end
end

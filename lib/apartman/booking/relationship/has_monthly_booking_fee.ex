defmodule Apartman.Booking.Relationship.HasMonthlyBookingFee do
  use Seraph.Schema.Relationship
  import Seraph.Changeset

  @cardinality [incoming: :one, outgoing: :one]

  relationship "HAS_MONTHLY_BOOKING_FEES" do
    start_node(Apartman.Booking.MonthlyBooking)
    end_node(Apartman.Invoice.BookingFee)

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

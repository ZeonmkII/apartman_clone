defmodule Apartman.Invoice.BookingFee do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Booking.{DailyBooking, MonthlyBooking}
  alias Apartman.Booking.Relationship.{HasDailyBookingFee, HasMonthlyBookingFee}

  node "BookingFee" do
    property(:deposit, :string)
    property(:bookingFees, :string)
    property(:roomFees, :string)
    property(:otherFees, :string)
    property(:remaining, :string)
    property(:total, :string)

    incoming_relationship(
      "HAS_DAILY_BOOKING_FEES",
      DailyBooking,
      :created_daily_by,
      HasDailyBookingFee,
      cardinality: :one
    )

    incoming_relationship(
      "HAS_MONTHLY_BOOKING_FEES",
      MonthlyBooking,
      :created_monthly_by,
      HasMonthlyBookingFee,
      cardinality: :one
    )
  end

  @doc false
  def changeset(booking_fee, attrs) do
    booking_fee
    |> cast(attrs, [:uuid, :bookingFees, :deposit, :roomFees, :otherFees, :remaining, :total])
    |> validate_required([:bookingFees, :deposit])
    |> calculate_remainder()
  end

  defp calculate_remainder(changeset) do
    total = get_field(changeset, :total) |> String.trim() |> String.to_float()
    booking_fees = get_field(changeset, :bookingFees) |> String.trim() |> String.to_float()
    remainder = total - booking_fees
    put_change(changeset, :remaining, Float.to_string(remainder))
  end
end

defmodule ApartmanWeb.Resolvers.BookingResolver do
  alias Apartman.Booking

  def checkins(_parent, _args, _resolution) do
    {:ok, Booking.list_checkins()}
  end

  def checkin(_parent, %{id: id}, _resolution) do
    {:ok, Booking.get_checkin!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def contracts(_parent, _args, _resolution) do
    {:ok, Booking.list_contracts()}
  end

  def contract(_parent, %{id: id}, _resolution) do
    {:ok, Booking.get_contract!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def daily_bookings(_parent, _args, _resolution) do
    {:ok, Booking.list_dailybookings()}
  end

  def daily_booking(_parent, %{id: id}, _resolution) do
    {:ok, Booking.get_daily_booking!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def monthly_bookings(_parent, _args, _resolution) do
    {:ok, Booking.list_monthlybookings()}
  end

  def monthly_booking(_parent, %{id: id}, _resolution) do
    {:ok, Booking.get_monthly_booking!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  defp node_to_absinthe(node) do
    if node do
      cond do
        # Contract node
        Map.has_key?(node, :contractId) ->
          %{
            id: node.uuid,
            contract_id: node.contractId,
            date_signed: node.dateSigned,
            check_in: node.checkIn,
            check_out: node.checkOut,
            room_number: node.roomNumber,
            rent_fees: node.rentFees,
            service_fees: node.serviceFees,
            duration_month: node.durationMonth,
            duration_day: node.durationDay,
            deposit: node.deposit,
            advance_payment: node.advancePayment,
            keycard_fees: node.keycardFees,
            keycard_number: node.keycardNumber,
            meter_water: node.meterWater,
            meter_electric: node.meterElectric,
            other_labels: node.otherLabels,
            other_fees: node.otherFees,
            remarks: node.remarks
          }

        # CheckIn node
        Map.has_key?(node, :timeIn) ->
          %{
            id: node.uuid,
            check_in: node.checkIn,
            check_out: node.checkOut,
            time_in: node.timeIn,
            time_out: node.timeOut,
            duration_day: node.durationDay,
            room_number: node.roomNumber,
            deposit: node.deposit,
            from: node.from,
            to: node.to,
            remarks: node.remarks
          }

        # MonthlyBooking node
        Map.has_key?(node, :durationMonth) ->
          %{
            id: node.uuid,
            booking_id: node.bookingId,
            check_in: node.checkIn,
            duration_month: node.durationMonth,
            duration_day: node.durationDay,
            remarks: node.remarks,
            rent_fees: node.rentFees,
            service_fees: node.serviceFees,
            deposit: node.deposit,
            advance_payment: node.advancePayment,
            keycard_fees: node.keycardFees,
            other_labels: node.otherLabels,
            other_fees: node.otherFees
          }

        # DailyBooking node
        Map.has_key?(node, :bookingId) ->
          %{
            id: node.uuid,
            booking_id: node.bookingId,
            check_in: node.checkIn,
            check_out: node.checkOut,
            duration_day: node.durationDay,
            remarks: node.remarks
          }
      end
    else
      nil
    end
  end
end

defmodule ApartmanWeb.ContractLive.Create do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking
  alias Apartman.Facility

  @impl true
  def mount(%{"id" => id, "booking_id" => booking_id}, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: page_title(socket.assigns.live_action),
        customer: Tenant.get_customer!(id),
        monthlyRent: %Tenant.MonthlyRent{},
        contract: booking_info(socket.assigns.live_action, booking_id),
        debug: false
      )
      |> fill_labels(booking_id)

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "update",
        %{
          "date_signed" => date_signed,
          "check_in" => check_in,
          "check_out" => check_out,
          "remarks" => remarks,
          "rent_fees" => rent_fees,
          "service_fees" => service_fees,
          "deposit" => deposit,
          "advance_payment" => advance_payment,
          "keycard_fees" => keycard_fees,
          "keycard_number" => keycard_number,
          "room_number" => room_number,
          "meter_electric" => meter_electric,
          "meter_water" => meter_water,
          "other_labels_1" => label_1,
          "other_fees_1" => fees_1,
          "other_labels_2" => label_2,
          "other_fees_2" => fees_2,
          "other_labels_3" => label_3,
          "other_fees_3" => fees_3,
          "other_labels_4" => label_4,
          "other_fees_4" => fees_4
        },
        socket
      ) do
    # Concat each otherLabels into one big String
    other_labels = label_1 <> " & " <> label_2 <> " & " <> label_3 <> " & " <> label_4
    other_fees = fees_1 <> " + " <> fees_2 <> " + " <> fees_3 <> " + " <> fees_4

    # Needed to put something in, otherwise changeset will drop this field
    remarks = (remarks == "" && " ") || remarks

    socket =
      socket
      |> assign(
        monthlyRent: %{
          bCurrent: true,
          bTenant: true,
          bContract: true
        }
      )
      |> assign(
        contract: %{
          dateSigned: date_signed,
          remarks: remarks,
          checkIn: check_in,
          checkOut: check_out,
          advancePayment: advance_payment,
          deposit: deposit,
          rentFees: rent_fees,
          serviceFees: service_fees,
          keycardFees: keycard_fees,
          keycardNumber: keycard_number,
          roomNumber: room_number,
          otherLabels: other_labels,
          otherFees: other_fees,
          meterElectric: meter_electric,
          meterWater: meter_water
        }
      )
      |> assign(
        other_label1: label_1,
        other_label2: label_2,
        other_label3: label_3,
        other_label4: label_4,
        other_fee1: fees_1,
        other_fee2: fees_2,
        other_fee3: fees_3,
        other_fee4: fees_4
      )

    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    {:noreply,
     socket
     |> push_redirect(
       to:
         Routes.contract_summary_path(socket, :show, %{
           id: socket.assigns.customer.uuid,
           rent: socket.assigns.monthlyRent,
           contract: socket.assigns.contract,
           booked: socket.assigns.prebooked,
           booking_id: socket.assigns.booking_id
         })
     )}
  end

  def handle_event("pick_room", _session, socket) do
    room = Facility.get_one_random_room()

    map =
      socket.assigns.contract
      |> Map.put(:roomNumber, room)
      |> Map.put(:keycardNumber, "KEY_" <> room)

    socket = assign(socket, contract: map)

    {:noreply, socket}
  end

  defp page_title(:new), do: "📒 สัญญาห้องพักรายเดือน (Walk-in)"
  defp page_title(:edit), do: "✍🏻 สัญญาห้องพักรายเดือน (Booked)"

  defp booking_info(:new, _id) do
    %Booking.Contract{}
    |> Map.put(:dateSigned, Date.utc_today())
  end

  defp booking_info(:edit, booking_id) do
    booking = Booking.get_monthly_booking!(booking_id)

    %Booking.Contract{
      dateSigned: Date.utc_today(),
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
      rentFees: booking.rentFees,
      serviceFees: booking.serviceFees,
      deposit: booking.deposit,
      advancePayment: booking.advancePayment,
      keycardFees: booking.keycardFees,
      otherLabels: booking.otherLabels,
      otherFees: booking.otherFees,
      remarks: booking.remarks
    }
  end

  defp fill_labels(socket, id) do
    case id == "" do
      true ->
        socket
        |> assign(
          other_label1: "",
          other_label2: "",
          other_label3: "",
          other_label4: "",
          other_fee1: "",
          other_fee2: "",
          other_fee3: "",
          other_fee4: "",
          prebooked: false,
          booking_id: ""
        )

      false ->
        booking = Booking.get_monthly_booking!(id)

        # หั่น OtherLabels และ OtherFees แล้วเอาใส่ TextInput แต่ละอัน
        list_labels = String.split(booking.otherLabels, " & ")
        list_fees = String.split(booking.otherFees, " + ")

        socket
        |> assign(
          other_label1: Enum.at(list_labels, 0),
          other_label2: Enum.at(list_labels, 1),
          other_label3: Enum.at(list_labels, 2),
          other_label4: Enum.at(list_labels, 3),
          other_fee1: Enum.at(list_fees, 0),
          other_fee2: Enum.at(list_fees, 1),
          other_fee3: Enum.at(list_fees, 2),
          other_fee4: Enum.at(list_fees, 3),
          prebooked: true,
          booking_id: booking.uuid
        )
    end
  end
end

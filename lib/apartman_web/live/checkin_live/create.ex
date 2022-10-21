defmodule ApartmanWeb.CheckinLive.Create do
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
        dailyRent: %Tenant.DailyRent{},
        checkin: booking_info(socket.assigns.live_action, booking_id),
        debug: false
      )
      |> fill_booking(booking_id)

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "update",
        %{
          "check_in" => check_in,
          "check_out" => check_out,
          "remarks" => remarks,
          "time_in" => time_in,
          "time_out" => time_out,
          "room_number" => room_number,
          "deposit" => deposit,
          "from" => from,
          "to" => to
        },
        socket
      ) do
    # Needed to put something in, otherwise changeset will drop this field
    remarks = (remarks == "" && " ") || remarks
    time_out = (time_out == "" && ~T[12:00:00]) || time_out

    socket =
      socket
      |> assign(
        dailyRent: %{
          bCurrent: true
        }
      )
      |> assign(
        checkin: %{
          remarks: remarks,
          checkIn: check_in,
          checkOut: check_out,
          timeIn: time_in,
          timeOut: time_out,
          roomNumber: room_number,
          deposit: deposit,
          from: from,
          to: to
        }
      )

    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    {:noreply,
     socket
     |> push_redirect(
       to:
         Routes.checkin_summary_path(socket, :show, %{
           id: socket.assigns.customer.uuid,
           rent: socket.assigns.dailyRent,
           checkin: socket.assigns.checkin,
           booking_id: socket.assigns.booking_id,
           booked: socket.assigns.prebooked
         })
     )}
  end

  def handle_event("pick_room", _session, socket) do
    room = Facility.get_one_random_room()

    map =
      socket.assigns.checkin
      |> Map.put(:roomNumber, room)

    socket = assign(socket, checkin: map)

    {:noreply, socket}
  end

  defp page_title(:new), do: "📒 เช็คอินห้องพักรายวัน (Walk-in)"
  defp page_title(:edit), do: "✍🏻 เช็คอินห้องพักรายวัน (Booked)"

  defp booking_info(:new, _id) do
    %Booking.Checkin{}
  end

  defp booking_info(:edit, booking_id) do
    booking = Booking.get_daily_booking!(booking_id)

    %Booking.Checkin{
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
      remarks: booking.remarks
    }
  end

  defp fill_booking(socket, id) do
    case id == "" do
      true ->
        socket
        |> assign(booking_id: "", prebooked: false)

      false ->
        booking = Booking.get_daily_booking!(id)

        socket
        |> assign(booking_id: booking.uuid, prebooked: true)
    end
  end
end

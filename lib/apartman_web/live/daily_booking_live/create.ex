defmodule ApartmanWeb.DailyBookingLive.Create do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      assign(socket,
        page_title: "📒 จองห้องพักรายวัน",
        customer: Tenant.get_customer!(id),
        dailyRent: %Tenant.DailyRent{},
        dailyBooking: %Booking.DailyBooking{},
        debug: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "update",
        %{
          "check_in" => check_in,
          "check_out" => check_out,
          "remarks" => remarks
        },
        socket
      ) do
    # Needed to put something in, otherwise changeset will drop this field
    remarks = (remarks == "" && " ") || remarks

    socket =
      socket
      |> assign(
        dailyRent: %{
          bCurrent: true
        }
      )
      |> assign(
        dailyBooking: %{
          remarks: remarks,
          checkIn: check_in,
          checkOut: check_out
        }
      )

    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    {:noreply,
     socket
     |> push_redirect(
       to:
         Routes.daily_booking_summary_path(socket, :show, %{
           id: socket.assigns.customer.uuid,
           rent: socket.assigns.dailyRent,
           booking: socket.assigns.dailyBooking
         })
     )}
  end
end

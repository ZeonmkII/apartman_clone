defmodule ApartmanWeb.DailyBookingLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Booking
  alias Apartman.Booking.DailyBooking

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :dailybookings, list_dailybookings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Daily booking")
    |> assign(:daily_booking, Booking.get_daily_booking!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Daily booking")
    |> assign(:daily_booking, %DailyBooking{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Dailybookings")
    |> assign(:daily_booking, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    daily_booking = Booking.get_daily_booking!(id)
    {:ok, _} = Booking.delete_daily_booking(daily_booking)

    {:noreply, assign(socket, :dailybookings, list_dailybookings())}
  end

  defp list_dailybookings do
    Booking.list_dailybookings()
  end
end

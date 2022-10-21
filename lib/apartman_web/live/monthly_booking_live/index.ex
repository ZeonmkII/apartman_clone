defmodule ApartmanWeb.MonthlyBookingLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Booking
  alias Apartman.Booking.MonthlyBooking

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :monthlybookings, list_monthlybookings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Monthly booking")
    |> assign(:monthly_booking, Booking.get_monthly_booking!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Monthly booking")
    |> assign(:monthly_booking, %MonthlyBooking{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Monthlybookings")
    |> assign(:monthly_booking, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    monthly_booking = Booking.get_monthly_booking!(id)
    {:ok, _} = Booking.delete_monthly_booking(monthly_booking)

    {:noreply, assign(socket, :monthlybookings, list_monthlybookings())}
  end

  defp list_monthlybookings do
    Booking.list_monthlybookings()
  end
end

defmodule ApartmanWeb.DailyBookingLive.Show do
  use ApartmanWeb, :live_view

  alias Apartman.Booking

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:daily_booking, Booking.get_daily_booking!(id))}
  end

  defp page_title(:show), do: "Show Daily booking"
  defp page_title(:edit), do: "Edit Daily booking"
end

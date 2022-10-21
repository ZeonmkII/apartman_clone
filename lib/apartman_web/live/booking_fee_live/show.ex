defmodule ApartmanWeb.BookingFeeLive.Show do
  use ApartmanWeb, :live_view

  alias Apartman.Invoice

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:booking_fee, Invoice.get_booking_fee!(id))}
  end

  defp page_title(:show), do: "Show Booking fee"
  defp page_title(:edit), do: "Edit Booking fee"
end

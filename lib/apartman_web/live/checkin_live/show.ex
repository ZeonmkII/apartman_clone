defmodule ApartmanWeb.CheckinLive.Show do
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
     |> assign(:checkin, Booking.get_checkin!(id))}
  end

  defp page_title(:show), do: "Show Checkin"
  defp page_title(:edit), do: "Edit Checkin"
end

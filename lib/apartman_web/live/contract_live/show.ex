defmodule ApartmanWeb.ContractLive.Show do
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
     |> assign(:contract, Booking.get_contract!(id))}
  end

  defp page_title(:show), do: "Show Contract"
  defp page_title(:edit), do: "Edit Contract"
end

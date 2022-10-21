defmodule ApartmanWeb.DailyRentLive.Show do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:daily_rent, Tenant.get_daily_rent!(id))}
  end

  defp page_title(:show), do: "Show Daily rent"
  defp page_title(:edit), do: "Edit Daily rent"
end

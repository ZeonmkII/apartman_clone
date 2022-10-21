defmodule ApartmanWeb.MonthlyRentLive.Show do
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
     |> assign(:monthly_rent, Tenant.get_monthly_rent!(id))}
  end

  defp page_title(:show), do: "Show Monthly rent"
  defp page_title(:edit), do: "Edit Monthly rent"
end

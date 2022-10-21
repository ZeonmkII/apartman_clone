defmodule ApartmanWeb.MonthlyRentLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Tenant.MonthlyRent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :monthlyrents, list_monthlyrents())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Monthly rent")
    |> assign(:monthly_rent, Tenant.get_monthly_rent!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Monthly rent")
    |> assign(:monthly_rent, %MonthlyRent{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Monthlyrents")
    |> assign(:monthly_rent, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    monthly_rent = Tenant.get_monthly_rent!(id)
    {:ok, _} = Tenant.delete_monthly_rent(monthly_rent)

    {:noreply, assign(socket, :monthlyrents, list_monthlyrents())}
  end

  defp list_monthlyrents do
    Tenant.list_monthlyrents()
  end
end

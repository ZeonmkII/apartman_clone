defmodule ApartmanWeb.DailyRentLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Tenant.DailyRent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :dailyrents, list_dailyrents())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Daily rent")
    |> assign(:daily_rent, Tenant.get_daily_rent!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Daily rent")
    |> assign(:daily_rent, %DailyRent{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Dailyrents")
    |> assign(:daily_rent, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    daily_rent = Tenant.get_daily_rent!(id)
    {:ok, _} = Tenant.delete_daily_rent(daily_rent)

    {:noreply, assign(socket, :dailyrents, list_dailyrents())}
  end

  defp list_dailyrents do
    Tenant.list_dailyrents()
  end
end

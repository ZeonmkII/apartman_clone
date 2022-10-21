defmodule ApartmanWeb.BuildingLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Facility
  alias Apartman.Facility.Building

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :buildings, list_buildings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Building")
    |> assign(:building, Facility.get_building!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Building")
    |> assign(:building, %Building{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Buildings")
    |> assign(:building, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    building = Facility.get_building!(id)
    {:ok, _} = Facility.delete_building(building)

    {:noreply, assign(socket, :buildings, list_buildings())}
  end

  defp list_buildings do
    Facility.list_buildings()
  end
end

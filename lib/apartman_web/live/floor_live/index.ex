defmodule ApartmanWeb.FloorLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Facility
  alias Apartman.Facility.Floor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :floors, list_floors())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Floor")
    |> assign(:floor, Facility.get_floor!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Floor")
    |> assign(:floor, %Floor{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Floors")
    |> assign(:floor, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    floor = Facility.get_floor!(id)
    {:ok, _} = Facility.delete_floor(floor)

    {:noreply, assign(socket, :floors, list_floors())}
  end

  defp list_floors do
    Facility.list_floors()
  end
end

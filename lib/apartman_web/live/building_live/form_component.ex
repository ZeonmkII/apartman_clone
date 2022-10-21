defmodule ApartmanWeb.BuildingLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Facility

  @impl true
  def update(%{building: building} = assigns, socket) do
    changeset = Facility.change_building(building)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"building" => building_params}, socket) do
    changeset =
      socket.assigns.building
      |> Facility.change_building(building_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"building" => building_params}, socket) do
    save_building(socket, socket.assigns.action, building_params)
  end

  defp save_building(socket, :edit, building_params) do
    case Facility.update_building(socket.assigns.building, building_params) do
      {:ok, _building} ->
        {:noreply,
         socket
         |> put_flash(:info, "Building updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_building(socket, :new, building_params) do
    case Facility.create_building(building_params) do
      {:ok, _building} ->
        {:noreply,
         socket
         |> put_flash(:info, "Building created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

defmodule ApartmanWeb.FloorLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Facility

  @impl true
  def update(%{floor: floor} = assigns, socket) do
    changeset = Facility.change_floor(floor)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"floor" => floor_params}, socket) do
    changeset =
      socket.assigns.floor
      |> Facility.change_floor(floor_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"floor" => floor_params}, socket) do
    save_floor(socket, socket.assigns.action, floor_params)
  end

  defp save_floor(socket, :edit, floor_params) do
    case Facility.update_floor(socket.assigns.floor, floor_params) do
      {:ok, _floor} ->
        {:noreply,
         socket
         |> put_flash(:info, "Floor updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_floor(socket, :new, floor_params) do
    case Facility.create_floor(floor_params) do
      {:ok, _floor} ->
        {:noreply,
         socket
         |> put_flash(:info, "Floor created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

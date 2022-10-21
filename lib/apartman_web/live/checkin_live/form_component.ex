defmodule ApartmanWeb.CheckinLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Booking

  @impl true
  def update(%{checkin: checkin} = assigns, socket) do
    changeset = Booking.change_checkin(checkin)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"checkin" => checkin_params}, socket) do
    changeset =
      socket.assigns.checkin
      |> Booking.change_checkin(checkin_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"checkin" => checkin_params}, socket) do
    save_checkin(socket, socket.assigns.action, checkin_params)
  end

  defp save_checkin(socket, :edit, checkin_params) do
    case Booking.update_checkin(socket.assigns.checkin, checkin_params) do
      {:ok, _checkin} ->
        {:noreply,
         socket
         |> put_flash(:info, "Checkin updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_checkin(socket, :new, checkin_params) do
    case Booking.create_checkin(checkin_params) do
      {:ok, _checkin} ->
        {:noreply,
         socket
         |> put_flash(:info, "Checkin created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

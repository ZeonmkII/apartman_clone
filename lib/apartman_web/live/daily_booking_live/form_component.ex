defmodule ApartmanWeb.DailyBookingLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Booking

  @impl true
  def update(%{daily_booking: daily_booking} = assigns, socket) do
    changeset = Booking.change_daily_booking(daily_booking)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"daily_booking" => daily_booking_params}, socket) do
    changeset =
      socket.assigns.daily_booking
      |> Booking.change_daily_booking(daily_booking_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"daily_booking" => daily_booking_params}, socket) do
    save_daily_booking(socket, socket.assigns.action, daily_booking_params)
  end

  defp save_daily_booking(socket, :edit, daily_booking_params) do
    case Booking.update_daily_booking(socket.assigns.daily_booking, daily_booking_params) do
      {:ok, _daily_booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Daily booking updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_daily_booking(socket, :new, daily_booking_params) do
    case Booking.create_daily_booking(daily_booking_params) do
      {:ok, _daily_booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Daily booking created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

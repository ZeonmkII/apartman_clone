defmodule ApartmanWeb.MonthlyBookingLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Booking

  @impl true
  def update(%{monthly_booking: monthly_booking} = assigns, socket) do
    changeset = Booking.change_monthly_booking(monthly_booking)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"monthly_booking" => monthly_booking_params}, socket) do
    changeset =
      socket.assigns.monthly_booking
      |> Booking.change_monthly_booking(monthly_booking_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"monthly_booking" => monthly_booking_params}, socket) do
    save_monthly_booking(socket, socket.assigns.action, monthly_booking_params)
  end

  defp save_monthly_booking(socket, :edit, monthly_booking_params) do
    case Booking.update_monthly_booking(socket.assigns.monthly_booking, monthly_booking_params) do
      {:ok, _monthly_booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Monthly booking updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_monthly_booking(socket, :new, monthly_booking_params) do
    case Booking.create_monthly_booking(monthly_booking_params) do
      {:ok, _monthly_booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Monthly booking created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

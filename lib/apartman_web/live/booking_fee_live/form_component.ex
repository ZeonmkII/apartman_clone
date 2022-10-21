defmodule ApartmanWeb.BookingFeeLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Invoice

  @impl true
  def update(%{booking_fee: booking_fee} = assigns, socket) do
    changeset = Invoice.change_booking_fee(booking_fee)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"booking_fee" => booking_fee_params}, socket) do
    changeset =
      socket.assigns.booking_fee
      |> Invoice.change_booking_fee(booking_fee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"booking_fee" => booking_fee_params}, socket) do
    save_booking_fee(socket, socket.assigns.action, booking_fee_params)
  end

  defp save_booking_fee(socket, :edit, booking_fee_params) do
    case Invoice.update_booking_fee(socket.assigns.booking_fee, booking_fee_params) do
      {:ok, _booking_fee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Booking fee updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_booking_fee(socket, :new, booking_fee_params) do
    case Invoice.create_booking_fee(booking_fee_params) do
      {:ok, _booking_fee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Booking fee created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

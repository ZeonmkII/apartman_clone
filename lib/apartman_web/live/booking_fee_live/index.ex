defmodule ApartmanWeb.BookingFeeLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Invoice
  alias Apartman.Invoice.BookingFee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :bookingfees, list_bookingfees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Booking fee")
    |> assign(:booking_fee, Invoice.get_booking_fee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Booking fee")
    |> assign(:booking_fee, %BookingFee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bookingfees")
    |> assign(:booking_fee, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    booking_fee = Invoice.get_booking_fee!(id)
    {:ok, _} = Invoice.delete_booking_fee(booking_fee)

    {:noreply, assign(socket, :bookingfees, list_bookingfees())}
  end

  defp list_bookingfees do
    Invoice.list_bookingfees()
  end
end

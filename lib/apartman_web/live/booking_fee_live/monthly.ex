defmodule ApartmanWeb.BookingFeeLive.Monthly do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      assign(socket,
        page_title: "Invoice for booking",
        customer: Tenant.get_customer!(id),
        deposit: "",
        booking_fees: "",
        room_fees: "",
        remaining: "",
        total: "",
        debug: true
      )

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "update",
        %{
          "deposit" => deposit,
          "booking_fees" => booking_fees,
          "room_fees" => room_fees,
          "remaining" => remaining,
          "total" => total
        },
        socket
      ) do
    socket =
      assign(socket,
      deposit: deposit,
      booking_fees: booking_fees,
      room_fees: room_fees,
      remaining: remaining,
      total: total
      )

    {:noreply, socket}
  end

  def handle_event("submit", _session, _socket) do
    #
  end
end

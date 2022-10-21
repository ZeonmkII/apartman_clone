defmodule ApartmanWeb.MonthlyInvoiceLive.Create do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      assign(socket,
        page_title: "Invoice ห้องพักรายเดือน",
        customer: Tenant.get_customer!(id),
        bill_cycle: "",
        advance_payment: "",
        water_start: "",
        water_end: "",
        water_unit: "",
        electric_start: "",
        electric_end: "",
        debug: true
      )

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "update",
        %{
          "bill_cycle" => bill_cycle,
          "advance_payment" => advance_payment,
          "water_start" => water_start,
          "water_end" => water_end,
          "water_unit" => water_unit,
          "electric_start" => electric_start,
          "electric_end" => electric_end
        },
        socket
      ) do
    socket =
      assign(socket,
      bill_cycle: bill_cycle,
      advance_payment: advance_payment,
      water_start: water_start,
      water_end: water_end,
      water_unit: water_unit,
      electric_start: electric_start,
      electric_end: electric_end
      )

    {:noreply, socket}
  end

  def handle_event("submit", _session, _socket) do
    #
  end
end

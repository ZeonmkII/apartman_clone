defmodule ApartmanWeb.DailyInvoiceLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Invoice
  alias Apartman.Invoice.DailyInvoice

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :dailyinvoices, list_dailyinvoices())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Daily invoice")
    |> assign(:daily_invoice, Invoice.get_daily_invoice!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Daily invoice")
    |> assign(:daily_invoice, %DailyInvoice{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Dailyinvoices")
    |> assign(:daily_invoice, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    daily_invoice = Invoice.get_daily_invoice!(id)
    {:ok, _} = Invoice.delete_daily_invoice(daily_invoice)

    {:noreply, assign(socket, :dailyinvoices, list_dailyinvoices())}
  end

  defp list_dailyinvoices do
    Invoice.list_dailyinvoices()
  end
end

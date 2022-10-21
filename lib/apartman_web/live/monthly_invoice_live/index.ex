defmodule ApartmanWeb.MonthlyInvoiceLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Invoice
  alias Apartman.Invoice.MonthlyInvoice

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :monthlyinvoices, list_monthlyinvoices())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Monthly invoice")
    |> assign(:monthly_invoice, Invoice.get_monthly_invoice!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Monthly invoice")
    |> assign(:monthly_invoice, %MonthlyInvoice{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Monthlyinvoices")
    |> assign(:monthly_invoice, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    monthly_invoice = Invoice.get_monthly_invoice!(id)
    {:ok, _} = Invoice.delete_monthly_invoice(monthly_invoice)

    {:noreply, assign(socket, :monthlyinvoices, list_monthlyinvoices())}
  end

  defp list_monthlyinvoices do
    Invoice.list_monthlyinvoices()
  end
end

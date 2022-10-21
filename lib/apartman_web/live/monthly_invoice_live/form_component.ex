defmodule ApartmanWeb.MonthlyInvoiceLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Invoice

  @impl true
  def update(%{monthly_invoice: monthly_invoice} = assigns, socket) do
    changeset = Invoice.change_monthly_invoice(monthly_invoice)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"monthly_invoice" => monthly_invoice_params}, socket) do
    changeset =
      socket.assigns.monthly_invoice
      |> Invoice.change_monthly_invoice(monthly_invoice_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"monthly_invoice" => monthly_invoice_params}, socket) do
    save_monthly_invoice(socket, socket.assigns.action, monthly_invoice_params)
  end

  defp save_monthly_invoice(socket, :edit, monthly_invoice_params) do
    case Invoice.update_monthly_invoice(socket.assigns.monthly_invoice, monthly_invoice_params) do
      {:ok, _monthly_invoice} ->
        {:noreply,
         socket
         |> put_flash(:info, "Monthly invoice updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_monthly_invoice(socket, :new, monthly_invoice_params) do
    case Invoice.create_monthly_invoice(monthly_invoice_params) do
      {:ok, _monthly_invoice} ->
        {:noreply,
         socket
         |> put_flash(:info, "Monthly invoice created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

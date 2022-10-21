defmodule ApartmanWeb.DailyInvoiceLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Invoice

  @impl true
  def update(%{daily_invoice: daily_invoice} = assigns, socket) do
    changeset = Invoice.change_daily_invoice(daily_invoice)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"daily_invoice" => daily_invoice_params}, socket) do
    changeset =
      socket.assigns.daily_invoice
      |> Invoice.change_daily_invoice(daily_invoice_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"daily_invoice" => daily_invoice_params}, socket) do
    save_daily_invoice(socket, socket.assigns.action, daily_invoice_params)
  end

  defp save_daily_invoice(socket, :edit, daily_invoice_params) do
    case Invoice.update_daily_invoice(socket.assigns.daily_invoice, daily_invoice_params) do
      {:ok, _daily_invoice} ->
        {:noreply,
         socket
         |> put_flash(:info, "Daily invoice updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_daily_invoice(socket, :new, daily_invoice_params) do
    case Invoice.create_daily_invoice(daily_invoice_params) do
      {:ok, _daily_invoice} ->
        {:noreply,
         socket
         |> put_flash(:info, "Daily invoice created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

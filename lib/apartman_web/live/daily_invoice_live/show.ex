defmodule ApartmanWeb.DailyInvoiceLive.Show do
  use ApartmanWeb, :live_view

  alias Apartman.Invoice

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:daily_invoice, Invoice.get_daily_invoice!(id))}
  end

  defp page_title(:show), do: "Show Daily invoice"
  defp page_title(:edit), do: "Edit Daily invoice"
end

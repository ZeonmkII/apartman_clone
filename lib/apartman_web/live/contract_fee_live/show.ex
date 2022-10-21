defmodule ApartmanWeb.ContractFeeLive.Show do
  use ApartmanWeb, :live_view

  alias Apartman.Receipt

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:contract_fee, Receipt.get_contract_fee!(id))}
  end

  defp page_title(:show), do: "Show Contract fee"
  defp page_title(:edit), do: "Edit Contract fee"
end

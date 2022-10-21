defmodule ApartmanWeb.ContractFeeLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Receipt
  alias Apartman.Receipt.ContractFee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :contractfees, list_contractfees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Contract fee")
    |> assign(:contract_fee, Receipt.get_contract_fee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Contract fee")
    |> assign(:contract_fee, %ContractFee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Contractfees")
    |> assign(:contract_fee, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contract_fee = Receipt.get_contract_fee!(id)
    {:ok, _} = Receipt.delete_contract_fee(contract_fee)

    {:noreply, assign(socket, :contractfees, list_contractfees())}
  end

  defp list_contractfees do
    Receipt.list_contractfees()
  end
end

defmodule ApartmanWeb.ContractLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Booking
  alias Apartman.Booking.Contract

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :contracts, list_contracts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Contract")
    |> assign(:contract, Booking.get_contract!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Contract")
    |> assign(:contract, %Contract{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Contracts")
    |> assign(:contract, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contract = Booking.get_contract!(id)
    {:ok, _} = Booking.delete_contract(contract)

    {:noreply, assign(socket, :contracts, list_contracts())}
  end

  defp list_contracts do
    Booking.list_contracts()
  end
end

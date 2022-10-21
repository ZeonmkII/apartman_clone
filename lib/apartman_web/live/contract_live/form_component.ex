defmodule ApartmanWeb.ContractLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Booking

  @impl true
  def update(%{contract: contract} = assigns, socket) do
    changeset = Booking.change_contract(contract)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"contract" => contract_params}, socket) do
    changeset =
      socket.assigns.contract
      |> Booking.change_contract(contract_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"contract" => contract_params}, socket) do
    save_contract(socket, socket.assigns.action, contract_params)
  end

  defp save_contract(socket, :edit, contract_params) do
    case Booking.update_contract(socket.assigns.contract, contract_params) do
      {:ok, _contract} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contract updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_contract(socket, :new, contract_params) do
    case Booking.create_contract(contract_params) do
      {:ok, _contract} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contract created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

defmodule ApartmanWeb.ContractFeeLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Receipt

  @impl true
  def update(%{contract_fee: contract_fee} = assigns, socket) do
    changeset = Receipt.change_contract_fee(contract_fee)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"contract_fee" => contract_fee_params}, socket) do
    changeset =
      socket.assigns.contract_fee
      |> Receipt.change_contract_fee(contract_fee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"contract_fee" => contract_fee_params}, socket) do
    save_contract_fee(socket, socket.assigns.action, contract_fee_params)
  end

  defp save_contract_fee(socket, :edit, contract_fee_params) do
    case Receipt.update_contract_fee(socket.assigns.contract_fee, contract_fee_params) do
      {:ok, _contract_fee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contract fee updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_contract_fee(socket, :new, contract_fee_params) do
    case Receipt.create_contract_fee(contract_fee_params) do
      {:ok, _contract_fee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contract fee created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

defmodule ApartmanWeb.CustomerLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Tenant

  @impl true
  def update(%{customer: customer} = assigns, socket) do
    changeset = Tenant.change_customer(customer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"customer" => customer_params}, socket) do
    changeset =
      socket.assigns.customer
      |> Tenant.change_customer(customer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"customer" => customer_params}, socket) do
    save_customer(socket, socket.assigns.action, customer_params)
  end

  defp save_customer(socket, :edit, customer_params) do
    case Tenant.update_customer(socket.assigns.customer, customer_params) do
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Customer updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_customer(socket, :new, customer_params) do
    case Tenant.create_customer(customer_params) do
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Customer created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

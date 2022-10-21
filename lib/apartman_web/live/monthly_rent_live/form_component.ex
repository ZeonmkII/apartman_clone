defmodule ApartmanWeb.MonthlyRentLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Tenant

  @impl true
  def update(%{monthly_rent: monthly_rent} = assigns, socket) do
    changeset = Tenant.change_monthly_rent(monthly_rent)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"monthly_rent" => monthly_rent_params}, socket) do
    changeset =
      socket.assigns.monthly_rent
      |> Tenant.change_monthly_rent(monthly_rent_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"monthly_rent" => monthly_rent_params}, socket) do
    save_monthly_rent(socket, socket.assigns.action, monthly_rent_params)
  end

  defp save_monthly_rent(socket, :edit, monthly_rent_params) do
    case Tenant.update_monthly_rent(socket.assigns.monthly_rent, monthly_rent_params) do
      {:ok, _monthly_rent} ->
        {:noreply,
         socket
         |> put_flash(:info, "Monthly rent updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_monthly_rent(socket, :new, monthly_rent_params) do
    case Tenant.create_monthly_rent(monthly_rent_params) do
      {:ok, _monthly_rent} ->
        {:noreply,
         socket
         |> put_flash(:info, "Monthly rent created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

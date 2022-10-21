defmodule ApartmanWeb.DailyRentLive.FormComponent do
  use ApartmanWeb, :live_component

  alias Apartman.Tenant

  @impl true
  def update(%{daily_rent: daily_rent} = assigns, socket) do
    changeset = Tenant.change_daily_rent(daily_rent)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"daily_rent" => daily_rent_params}, socket) do
    changeset =
      socket.assigns.daily_rent
      |> Tenant.change_daily_rent(daily_rent_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"daily_rent" => daily_rent_params}, socket) do
    save_daily_rent(socket, socket.assigns.action, daily_rent_params)
  end

  defp save_daily_rent(socket, :edit, daily_rent_params) do
    case Tenant.update_daily_rent(socket.assigns.daily_rent, daily_rent_params) do
      {:ok, _daily_rent} ->
        {:noreply,
         socket
         |> put_flash(:info, "Daily rent updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_daily_rent(socket, :new, daily_rent_params) do
    case Tenant.create_daily_rent(daily_rent_params) do
      {:ok, _daily_rent} ->
        {:noreply,
         socket
         |> put_flash(:info, "Daily rent created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Seraph.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

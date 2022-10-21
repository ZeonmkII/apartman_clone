defmodule ApartmanWeb.CheckinLive.Index do
  use ApartmanWeb, :live_view

  alias Apartman.Booking
  alias Apartman.Booking.Checkin

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :checkins, list_checkins())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Checkin")
    |> assign(:checkin, Booking.get_checkin!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Checkin")
    |> assign(:checkin, %Checkin{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Checkins")
    |> assign(:checkin, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    checkin = Booking.get_checkin!(id)
    {:ok, _} = Booking.delete_checkin(checkin)

    {:noreply, assign(socket, :checkins, list_checkins())}
  end

  defp list_checkins do
    Booking.list_checkins()
  end
end

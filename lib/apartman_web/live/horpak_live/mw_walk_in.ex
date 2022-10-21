defmodule ApartmanWeb.HorpakLive.MwWalkIn do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "เพิ่มรายการจองห้องพัก walk-in")

    {:ok, socket}
  end
end

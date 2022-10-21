defmodule ApartmanWeb.HorpakLive.DbBooking do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "เพิ่มการจองรายวัน")

    {:ok, socket}
  end
end

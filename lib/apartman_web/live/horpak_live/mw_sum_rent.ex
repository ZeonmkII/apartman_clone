defmodule ApartmanWeb.HorpakLive.MwSumRent do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "สรุปข้อมูลการจองห้องพัก")

    {:ok, socket}
  end
end

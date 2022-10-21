defmodule ApartmanWeb.HorpakLive.MbwMoreFees do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "ค่าใช้จ่ายเพิ่มเติม")

    {:ok, socket}
  end
end

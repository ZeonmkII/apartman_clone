defmodule ApartmanWeb.TestLive.Customer do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "เพิ่มข้อมูลลูกค้า")

    {:ok, socket}
  end
end

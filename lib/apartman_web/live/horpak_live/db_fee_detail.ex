defmodule ApartmanWeb.HorpakLive.DbFeeDetail do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "รายละเอียดค่าใช้จ่าย")

    {:ok, socket}
  end
end

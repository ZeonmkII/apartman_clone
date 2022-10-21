defmodule ApartmanWeb.HorpakLive.SelectRoom do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "เลือกห้อง")

    {:ok, socket}
  end
end

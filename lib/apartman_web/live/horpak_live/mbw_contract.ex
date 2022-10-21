
defmodule ApartmanWeb.HorpakLive.MbwContract do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "ทำสัญญาเช่า")

    {:ok, socket}
  end
end

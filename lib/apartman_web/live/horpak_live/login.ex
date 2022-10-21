defmodule ApartmanWeb.HorpakLive.Login do
    use ApartmanWeb, :live_view
  
    @impl true
    def mount(_params, _session, socket) do
      socket =
        assign(socket, :page_title, "เข้าสู่ระบบ")
        |> assign(:placeholder_username, "somchui")
        |> assign(:placeholder_password, "********")
  
      {:ok, socket}
    end
  end
  
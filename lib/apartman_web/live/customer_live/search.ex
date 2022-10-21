defmodule ApartmanWeb.CustomerLive.Search do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        page_title: "ค้นหาข้อมูลลูกค้า",
        id_number: "",
        customers: list_customers(),
        error: false,
        error_msg: "",
        debug: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("update", %{"input_id_number" => id_number}, socket) do
    socket = assign(socket, id_number: id_number)
    {:noreply, socket}
  end

  def handle_event("submit", %{"input_id_number" => id}, socket) do
    case Tenant.get_customer_by_id_number(id) do
      nil ->
        {:noreply,
         socket
         |> assign(error: true, error_msg: "⚠️ ไม่พบข้อมูลผู้ใช้ เลขประจำตัวประชาชน : #{id}")}

      _customer ->
        {:noreply,
         push_redirect(socket, to: Routes.customer_dashboard_path(socket, :show, id: id))}
    end
  end

  def handle_event("new_customer", _assign, socket) do
    {:noreply, push_redirect(socket, to: Routes.customer_create_path(socket, :new))}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} = Tenant.delete_customer(id)

    {:noreply, assign(socket, :customers, list_customers())}
  end

  defp list_customers do
    Tenant.list_customers()
  end
end

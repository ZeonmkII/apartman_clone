
defmodule ApartmanWeb.HorpakLive.MbBooking do
  use ApartmanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "เพิ่มรายการจองห้องพักรายเดือน")

    {:ok, socket}
  end
end



# defmodule ApartmanWeb.HorpakLive.MbBooking do
#   use ApartmanWeb, :live_view

#   alias Apartman.Tenant

#   @impl true
#   def mount(%{"id" => id}, _session, socket) do
#     socket =
#       assign(socket,
#         page_title: "เพิ่มรายการจองห้องพักรายเดือน",
#         customer: Tenant.get_customer!(id),
#         check_in: "",
#         advance_payment: "",
#         remarks: "",
#         debug: false
#       )

#     {:ok, socket}
#   end

#   @impl true
#   def handle_event(
#         "update",
#         %{
#           "date_in" => date_in,
#           "advance_payment" => advance_payment,
#           "remarks" => remarks
#         },
#         socket
#       ) do
#     socket =
#       assign(socket, remarks: remarks, check_in: date_in, check_out: date_out, deposit: deposit)

#     {:noreply, socket}
#   end

#   def handle_event("submit", _session, _socket) do
#     #
#   end
# end







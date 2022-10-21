defmodule ApartmanWeb.DailyBookingLive.Summary do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking
  alias Apartman.Tenant.Relationship.{RentDaily, ReserveDaily}
  alias Apartman.Repo

  @impl true
  def mount(%{"id" => id, "rent" => rent_val, "booking" => booking_val}, _session, socket) do
    # จับเข้า changeset เพื่อให้มัน cast เป็น DataType ที่ถูกต้อง  (ไม่งั้นทุกอย่างจะเป็น string)
    daily_rent = %Tenant.DailyRent{} |> Tenant.DailyRent.changeset(rent_val)
    daily_booking = %Booking.DailyBooking{} |> Booking.DailyBooking.changeset(booking_val)

    socket =
      assign(socket,
        page_title: "⚠️ ยืนยันการจอง ห้องพักรายวัน ⚠️",
        customer: Tenant.get_customer!(id),
        dailyRent: daily_rent.changes,
        dailyBooking: daily_booking.changes,
        debug: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("update", _assign, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    # !-- 1 --! Create DailyRent (in 'Tenant' context) first
    with {:ok, dailyrent_node} <- Tenant.create_daily_rent(socket.assigns.dailyRent) do
      # ---------------- (Customer)-[RENT_MONTHLY]->(MonthlyRent) ----------------
      customer_node = Tenant.get_customer!(socket.assigns.customer.uuid)

      drent_rel = %{
        start_node: customer_node,
        end_node: dailyrent_node
      }

      drent_relationship = %RentDaily{} |> RentDaily.changeset(drent_rel)
      {:ok, _drent_rel} = Repo.Relationship.create(drent_relationship)
      # ==================================================================================
      # !-- 2 --! Create MonthlyBooking (in 'Booking' context)
      with {:ok, dailybooking_node} <-
             Booking.create_daily_booking(socket.assigns.dailyBooking) do
        # ------------- (DailyRent)-[RENT_DAILY]->(DailyBooking) -------------
        dbook_rel = %{
          start_node: dailyrent_node,
          end_node: dailybooking_node
        }

        dbook_relationship = %ReserveDaily{} |> ReserveDaily.changeset(dbook_rel)
        {:ok, _dbook_rel} = Repo.Relationship.create(dbook_relationship)
        # ================================================================================
      end

      # !-- 3 --! !TODO: Redirect user to Invoice page *** ตอนนี้ยิงไปหน้า User Dashboard ไปก่อน ***
      {:noreply,
       socket
       |> push_redirect(
         to: Routes.customer_dashboard_path(socket, :show, id: socket.assigns.customer.idNumber)
       )}
    end
  end
end

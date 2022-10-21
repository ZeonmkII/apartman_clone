defmodule ApartmanWeb.MonthlyBookingLive.Summary do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking
  alias Apartman.Tenant.Relationship.{RentMonthly, ReserveMonthly}
  alias Apartman.Repo

  @impl true
  def mount(%{"id" => id, "rent" => rent_val, "booking" => booking_val}, _session, socket) do
    # จับเข้า changeset เพื่อให้มัน cast เป็น DataType ที่ถูกต้อง  (ไม่งั้นทุกอย่างจะเป็น string)
    monthly_rent = %Tenant.MonthlyRent{} |> Tenant.MonthlyRent.changeset(rent_val)
    monthly_booking = %Booking.MonthlyBooking{} |> Booking.MonthlyBooking.changeset(booking_val)

    socket =
      assign(socket,
        page_title: "⚠️ ยืนยันการจอง ห้องพักรายเดือน ⚠️",
        customer: Tenant.get_customer!(id),
        monthlyRent: monthly_rent.changes,
        monthlyBooking: monthly_booking.changes,
        debug: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("update", _assign, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    # !-- 1 --! Create MonthlyRent (in 'Tenant' context) first
    with {:ok, monthlyrent_node} <- Tenant.create_monthly_rent(socket.assigns.monthlyRent) do
      # ---------------- (Customer)-[RENT_MONTHLY]->(MonthlyRent) ----------------
      customer_node = Tenant.get_customer!(socket.assigns.customer.uuid)

      mrent_rel = %{
        start_node: customer_node,
        end_node: monthlyrent_node
      }

      mrent_relationship = %RentMonthly{} |> RentMonthly.changeset(mrent_rel)
      {:ok, _mrent_rel} = Repo.Relationship.create(mrent_relationship)
      # ==================================================================================
      # !-- 2 --! Create MonthlyBooking (in 'Booking' context)
      with {:ok, monthlybooking_node} <-
             Booking.create_monthly_booking(socket.assigns.monthlyBooking) do
        # ------------- (MonthlyRent)-[RENT_MONTHLY]->(MonthlyBooking) -------------
        mbook_rel = %{
          start_node: monthlyrent_node,
          end_node: monthlybooking_node
        }

        mbook_relationship = %ReserveMonthly{} |> ReserveMonthly.changeset(mbook_rel)
        {:ok, _mbook_rel} = Repo.Relationship.create(mbook_relationship)
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

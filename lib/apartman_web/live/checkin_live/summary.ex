defmodule ApartmanWeb.CheckinLive.Summary do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking
  alias Apartman.Booking.Relationship.SignCheckin, as: BookingSign
  alias Apartman.Booking.Relationship.OccupyDaily
  alias Apartman.Tenant.Relationship.SignCheckin, as: TenantSign
  alias Apartman.Tenant.Relationship.RentDaily
  alias Apartman.Facility
  alias Apartman.Repo

  @impl true
  def mount(
        %{
          "id" => id,
          "checkin" => checkin_val,
          "rent" => rent_val,
          "booking_id" => booking_id,
          "booked" => booked
        },
        _session,
        socket
      ) do
    daily_rent = %Tenant.DailyRent{} |> Tenant.DailyRent.changeset(rent_val)
    checkin = %Booking.Checkin{} |> Booking.Checkin.changeset(checkin_val)

    socket =
      socket
      |> assign(
        page_title: "⚠️ ยืนยันการเข้าพัก ห้องพักรายวัน ⚠️",
        customer: Tenant.get_customer!(id),
        dailyRent: daily_rent.changes,
        checkin: checkin.changes,
        prebooked: booked,
        booking_id: booking_id,
        debug: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("update", _assign, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    case socket.assigns.prebooked do
      "true" ->
        # ให้ MonthlyBooking เป็น Parent
        dailybooking_node = Booking.get_daily_booking!(socket.assigns.booking_id)

        with {:ok, checkin_node} <- Booking.create_checkin(socket.assigns.checkin) do
          # ------------- (DailyBooking)-[SIGN_CHECKIN]->(Checkin) -------------
          dbook_rel = %{
            start_node: dailybooking_node,
            end_node: checkin_node
          }

          dbook_relationship =
            %BookingSign{}
            |> BookingSign.changeset(dbook_rel)

          {:ok, _mbook_rel} = Repo.Relationship.create(dbook_relationship)
          # ไปจองห้อง
          room_node = Facility.get_room_by_number(socket.assigns.checkin.roomNumber)

          room_rel = %{
            start_node: checkin_node,
            end_node: room_node,
            dateFirst: socket.assigns.checkin.checkIn,
            dateLast: socket.assigns.checkin.checkOut
          }

          room_relationship = %OccupyDaily{} |> OccupyDaily.changeset(room_rel)
          {:ok, _room_rel} = Repo.Relationship.create(room_relationship)

          # Mark Room as Occupied
          update_room_data = %{
            bOccupied: true
          }

          {:ok, _room_node} = Facility.update_room(room_node, update_room_data)
        end

      "false" ->
        # สร้าง DailyRent ก่อน
        with {:ok, dailyrent_node} <- Tenant.create_daily_rent(socket.assigns.dailyRent) do
          customer_node = Tenant.get_customer!(socket.assigns.customer.uuid)

          drent_rel = %{
            start_node: customer_node,
            end_node: dailyrent_node
          }

          drent_relationship = %RentDaily{} |> RentDaily.changeset(drent_rel)
          {:ok, _drent_rel} = Repo.Relationship.create(drent_relationship)
          # แล้วให้ DailyRent มาเป็น Parent
          with {:ok, checkin_node} <- Booking.create_checkin(socket.assigns.checkin) do
            # ------------- (DailyRent)-[WALKIN_DAILY]->(Checkin) -------------
            dbook_rel = %{
              start_node: dailyrent_node,
              end_node: checkin_node
            }

            dbook_relationship =
              %TenantSign{}
              |> TenantSign.changeset(dbook_rel)

            {:ok, _dbook_rel} = Repo.Relationship.create(dbook_relationship)
            # ไปจองห้อง
            room_node = Facility.get_room_by_number(socket.assigns.checkin.roomNumber)

            room_rel = %{
              start_node: checkin_node,
              end_node: room_node,
              dateFirst: socket.assigns.checkin.checkIn,
              dateLast: socket.assigns.checkin.checkOut
            }

            room_relationship = %OccupyDaily{} |> OccupyDaily.changeset(room_rel)
            {:ok, _room_rel} = Repo.Relationship.create(room_relationship)

            # Mark Room as Occupied
            update_room_data = %{
              bOccupied: true
            }

            {:ok, _room_node} = Facility.update_room(room_node, update_room_data)
          end
        end
    end

    # !TODO: Redirect user to Invoice page *** ตอนนี้ยิงไปหน้า User Dashboard ไปก่อน ***
    {:noreply,
     socket
     |> push_redirect(
       to: Routes.customer_dashboard_path(socket, :show, id: socket.assigns.customer.idNumber)
     )}
  end
end

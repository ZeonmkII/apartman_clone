defmodule ApartmanWeb.ContractLive.Summary do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking
  alias Apartman.Booking.Relationship.SignContract, as: BookingSign
  alias Apartman.Booking.Relationship.OccupyMonthly
  alias Apartman.Tenant.Relationship.RentMonthly
  alias Apartman.Tenant.Relationship.SignContract, as: TenantSign
  alias Apartman.Facility
  alias Apartman.Repo

  @impl true
  def mount(
        %{
          "id" => id,
          "contract" => contract_val,
          "rent" => rent_val,
          "booked" => booked,
          "booking_id" => booking_id
        },
        _session,
        socket
      ) do
    monthly_rent = %Tenant.MonthlyRent{} |> Tenant.MonthlyRent.changeset(rent_val)
    contrct = %Booking.Contract{} |> Booking.Contract.changeset(contract_val)

    socket =
      assign(socket,
        page_title: "⚠️ ยืนยันสัญญา ห้องพักรายเดือน ⚠️",
        customer: Tenant.get_customer!(id),
        monthlyRent: monthly_rent.changes,
        contract: contrct.changes,
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
        monthlybooking_node = Booking.get_monthly_booking!(socket.assigns.booking_id)

        with {:ok, contract_node} <- Booking.create_contract(socket.assigns.contract) do
          # ------------- (MonthlyBooking)-[SIGN_CONTRACT]->(Contract) -------------
          mbook_rel = %{
            start_node: monthlybooking_node,
            end_node: contract_node
          }

          mbook_relationship =
            %BookingSign{}
            |> BookingSign.changeset(mbook_rel)

          {:ok, _mbook_rel} = Repo.Relationship.create(mbook_relationship)
          # ไปจองห้อง
          room_node = Facility.get_room_by_number(socket.assigns.contract.roomNumber)

          room_rel = %{
            start_node: contract_node,
            end_node: room_node,
            dateFirst: socket.assigns.contract.checkIn,
            dateLast: socket.assigns.contract.checkOut
          }

          room_relationship = %OccupyMonthly{} |> OccupyMonthly.changeset(room_rel)
          {:ok, _room_rel} = Repo.Relationship.create(room_relationship)

          # Mark Room as Occupied
          update_room_data = %{
            bOccupied: true
          }

          {:ok, _room_node} = Facility.update_room(room_node, update_room_data)
        end

      "false" ->
        # สร้าง MonthlyRent ก่อน
        with {:ok, monthlyrent_node} <- Tenant.create_monthly_rent(socket.assigns.monthlyRent) do
          customer_node = Tenant.get_customer!(socket.assigns.customer.uuid)

          mrent_rel = %{
            start_node: customer_node,
            end_node: monthlyrent_node
          }

          mrent_relationship = %RentMonthly{} |> RentMonthly.changeset(mrent_rel)
          {:ok, _mrent_rel} = Repo.Relationship.create(mrent_relationship)

          # แล้วให้ MonthlyRent มาเป็น Parent
          with {:ok, contract_node} <- Booking.create_contract(socket.assigns.contract) do
            # ------------- (MonthlyRent)-[WALKIN_MONTHLY]->(Contract) -------------
            mbook_rel = %{
              start_node: monthlyrent_node,
              end_node: contract_node
            }

            mbook_relationship =
              %TenantSign{}
              |> TenantSign.changeset(mbook_rel)

            {:ok, _mbook_rel} = Repo.Relationship.create(mbook_relationship)
            # ไปจองห้อง
            room_node = Facility.get_room_by_number(socket.assigns.contract.roomNumber)

            room_rel = %{
              start_node: contract_node,
              end_node: room_node,
              dateFirst: socket.assigns.contract.checkIn,
              dateLast: socket.assigns.contract.checkOut
            }

            room_relationship = %OccupyMonthly{} |> OccupyMonthly.changeset(room_rel)
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

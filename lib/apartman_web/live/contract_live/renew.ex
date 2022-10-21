defmodule ApartmanWeb.ContractLive.Renew do
  use ApartmanWeb, :live_view

  alias Apartman.Booking
  alias Apartman.Booking.Relationship.SignContract, as: BookingSign
  alias Apartman.Booking.Relationship.OccupyMonthly
  alias Apartman.Tenant
  alias Apartman.Tenant.Relationship.SignContract, as: TenantSign
  alias Apartman.Facility
  alias Bolt.Sips, as: Neo
  alias Apartman.Repo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      assign(socket,
        page_title: "⏱️ ต่อสัญญา ห้องพักรายเดือน",
        contract: Booking.get_contract!(id),
        old_id: id,
        debug: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "update",
        %{
          "check_in" => check_in,
          "check_out" => check_out,
          "rent_fees" => rent_fees
        },
        socket
      ) do
    # Get old values
    tmp = socket.assigns.contract

    socket =
      socket
      |> assign(
        contract: %{
          dateSigned: tmp.dateSigned,
          remarks: tmp.remarks,
          checkIn: check_in,
          checkOut: check_out,
          advancePayment: tmp.advancePayment,
          deposit: tmp.deposit,
          rentFees: rent_fees,
          serviceFees: tmp.serviceFees,
          keycardFees: tmp.keycardFees,
          keycardNumber: tmp.keycardNumber,
          roomNumber: tmp.roomNumber,
          otherLabels: tmp.otherLabels,
          otherFees: tmp.otherFees,
          meterElectric: tmp.meterElectric,
          meterWater: tmp.meterWater
        }
      )

    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    # Get Parent node of the old Contract
    old_contract = Booking.get_contract!(socket.assigns.old_id)
    conn = Neo.conn()
    query = "MATCH (p)-->(c:Contract {uuid: \"#{old_contract.uuid}\"}) RETURN p AS Parent"
    response = Neo.query!(conn, query)

    parent =
      Enum.map(response.results, & &1["Parent"])
      |> Enum.map(& &1.properties)
      |> List.first()

    [[parent_type]] = Enum.map(response.results, & &1["Parent"]) |> Enum.map(& &1.labels)

    case parent_type do
      "MonthlyRent" ->
        parent_node = Tenant.get_monthly_rent!(parent["uuid"])

        with {:ok, contract_node} <- Booking.create_contract(socket.assigns.contract) do
          rel = %{
            start_node: parent_node,
            end_node: contract_node
          }

          walkin_rel =
            %TenantSign{}
            |> TenantSign.changeset(rel)

          {:ok, _mbook_rel} = Repo.Relationship.create(walkin_rel)
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

      "MonthlyBooking" ->
        parent_node = Booking.get_monthly_booking!(parent["uuid"])

        with {:ok, contract_node} <- Booking.create_contract(socket.assigns.contract) do
          rel = %{
            start_node: parent_node,
            end_node: contract_node
          }

          booked_rel =
            %BookingSign{}
            |> BookingSign.changeset(rel)

          {:ok, _mbook_rel} = Repo.Relationship.create(booked_rel)
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

    # !TODO: Redirect user to Invoice page *** ตอนนี้ยิงไปหน้า User Dashboard ไปก่อน ***
    {:noreply,
     socket
     |> push_redirect(to: Routes.customer_dashboard_path(socket, :show, id: "1101400929323"))}
  end
end

defmodule ApartmanWeb.CustomerLive.Dashboard do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking
  alias Elixlsx.Workbook
  alias Elixlsx.Sheet

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:customer, Tenant.get_customer_by_id_number(id))
     |> assign(:monthly_bookings, list_monthly_bookings(id))
     |> assign(:contracts, list_contracts(id))
     |> assign(:daily_bookings, list_daily_bookings(id))
     |> assign(:checkins, list_checkins(id))
     |> assign(:today, get_current_date())
     |> assign(:show_customer_info, false)
     |> assign(:show_monthly_bookings, true)
     |> assign(:show_daily_bookings, true)
     |> assign(:show_contracts, true)
     |> assign(:show_checkins, true)
     |> assign(:debug, false)}
  end

  @impl true
  def handle_event("toggle_customer_info", _session, socket) do
    case socket.assigns.show_customer_info do
      true -> {:noreply, socket |> assign(:show_customer_info, false)}
      false -> {:noreply, socket |> assign(:show_customer_info, true)}
    end
  end

  def handle_event("toggle_monthly_bookings", _session, socket) do
    case socket.assigns.show_monthly_bookings do
      true -> {:noreply, socket |> assign(:show_monthly_bookings, false)}
      false -> {:noreply, socket |> assign(:show_monthly_bookings, true)}
    end
  end

  def handle_event("toggle_daily_bookings", _session, socket) do
    case socket.assigns.show_daily_bookings do
      true -> {:noreply, socket |> assign(:show_daily_bookings, false)}
      false -> {:noreply, socket |> assign(:show_daily_bookings, true)}
    end
  end

  def handle_event("toggle_contracts", _session, socket) do
    case socket.assigns.show_contracts do
      true -> {:noreply, socket |> assign(:show_contracts, false)}
      false -> {:noreply, socket |> assign(:show_contracts, true)}
    end
  end

  def handle_event("toggle_checkins", _session, socket) do
    case socket.assigns.show_checkins do
      true -> {:noreply, socket |> assign(:show_checkins, false)}
      false -> {:noreply, socket |> assign(:show_checkins, true)}
    end
  end

  def handle_event("book_monthly", %{"value" => id}, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.monthly_booking_create_path(socket, :new, id: id)
     )}
  end

  def handle_event("walkin_monthly", %{"value" => id}, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.contract_create_path(socket, :new, %{id: id, booking_id: ""})
     )}
  end

  def handle_event("book_daily", %{"value" => id}, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.daily_booking_create_path(socket, :new, id: id)
     )}
  end

  def handle_event("walkin_daily", %{"value" => id}, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.checkin_create_path(socket, :new, %{id: id, booking_id: ""})
     )}
  end

  def handle_event("make_contract", %{"id" => id}, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.contract_create_path(socket, :edit, %{
           id: socket.assigns.customer.uuid,
           booking_id: id
         })
     )}
  end

  def handle_event("make_checkin", %{"id" => id}, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.checkin_create_path(socket, :edit, %{
           id: socket.assigns.customer.uuid,
           booking_id: id
         })
     )}
  end

  def handle_event("renew_contract", %{"id" => id}, socket) do
    {:noreply, push_redirect(socket, to: Routes.contract_renew_path(socket, :new, %{id: id}))}
  end

  def handle_event("renew_checkin", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_m_booking", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_d_booking", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_contract", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_checkin", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("delete_m_booking", %{"id" => id}, socket) do
    Booking.delete_monthly_booking(id)
    {:noreply, push_patch(socket, to: "#")}
  end

  def handle_event("delete_d_booking", %{"id" => id}, socket) do
    Booking.delete_daily_booking(id)
    {:noreply, push_patch(socket, to: "#")}
  end

  def handle_event("delete_contract", %{"id" => id}, socket) do
    Booking.delete_contract(id)
    {:noreply, push_patch(socket, to: "#")}
  end

  def handle_event("delete_checkin", %{"id" => id}, socket) do
    Booking.delete_checkin(id)
    {:noreply, push_patch(socket, to: "#")}
  end

  def handle_event("print_m_booking", %{"id" => id}, socket) do
    booking = Booking.get_monthly_booking!(id)

    sheet_name =
      Sheet.with_name("MonthlyBooking")
      # Header
      |> Sheet.set_cell("A1", "FirstName", bold: true)
      |> Sheet.set_cell("B1", "LastName", bold: true)
      |> Sheet.set_cell("C1", "Phone", bold: true)
      |> Sheet.set_cell("E1", "Date", bold: true)
      |> Sheet.set_cell("G1", "Checkin", bold: true)
      |> Sheet.set_cell("H1", "DurationDay", bold: true)
      |> Sheet.set_cell("I1", "DurationMonth", bold: true)
      |> Sheet.set_cell("J1", "Remarks", bold: true)
      # Data
      |> Sheet.set_cell("A2", socket.assigns.customer.firstName)
      |> Sheet.set_cell("B2", socket.assigns.customer.lastName)
      |> Sheet.set_cell("C2", socket.assigns.customer.phone)
      |> Sheet.set_cell("E2", Date.to_string(socket.assigns.today))
      |> Sheet.set_cell("G2", Date.to_string(booking.checkIn))
      |> Sheet.set_cell("H2", booking.durationDay)
      |> Sheet.set_cell("I2", booking.durationMonth)
      |> Sheet.set_cell("J2", booking.remarks)

    %Workbook{sheets: [sheet_name]}
    |> Elixlsx.write_to(
      "db_#{socket.assigns.customer.firstName}_#{socket.assigns.customer.lastName}_MonthlyBooking.xlsx"
    )

    {:noreply, socket |> put_flash(:info, "Export 'การจองรายเดือน' สำเร็จ.")}
  end

  def handle_event("print_d_booking", %{"id" => id}, socket) do
    booking = Booking.get_daily_booking!(id)

    sheet_name =
      Sheet.with_name("DailyBooking")
      # Header
      |> Sheet.set_cell("A1", "FirstName", bold: true)
      |> Sheet.set_cell("B1", "LastName", bold: true)
      |> Sheet.set_cell("C1", "Phone", bold: true)
      |> Sheet.set_cell("E1", "Date", bold: true)
      |> Sheet.set_cell("G1", "Checkin", bold: true)
      |> Sheet.set_cell("H1", "DurationDay", bold: true)
      |> Sheet.set_cell("I1", "Remarks", bold: true)
      # Data
      |> Sheet.set_cell("A2", socket.assigns.customer.firstName)
      |> Sheet.set_cell("B2", socket.assigns.customer.lastName)
      |> Sheet.set_cell("C2", socket.assigns.customer.phone)
      |> Sheet.set_cell("E2", Date.to_string(socket.assigns.today))
      |> Sheet.set_cell("G2", Date.to_string(booking.checkIn))
      |> Sheet.set_cell("H2", booking.durationDay)
      |> Sheet.set_cell("I2", booking.remarks)

    %Workbook{sheets: [sheet_name]}
    |> Elixlsx.write_to(
      "db_#{socket.assigns.customer.firstName}_#{socket.assigns.customer.lastName}_DailyBooking.xlsx"
    )

    {:noreply, socket |> put_flash(:info, "Export 'การจองรายวัน' สำเร็จ.")}
  end

  # today
  # user (who created the contract)
  # name surname age  id_number
  # (id card + personal info stuffs)
  # telephone
  # room_no floor_no
  # check-in check-out duration_month
  # adv_payment service_fees
  # meter_water meter_electric
  # deposit rent_fees keycard_fees
  # keycard_no

  def handle_event("print_contract", %{"id" => id}, socket) do
    contract = Booking.get_contract!(id)

    sheet_name =
      Sheet.with_name("Contract")
      # Header
      |> Sheet.set_cell("A1", "FirstName", bold: true)
      |> Sheet.set_cell("B1", "LastName", bold: true)
      |> Sheet.set_cell("C1", "Phone", bold: true)
      |> Sheet.set_cell("E1", "Date", bold: true)
      |> Sheet.set_cell("G1", "Checkin", bold: true)
      |> Sheet.set_cell("H1", "DurationDay", bold: true)
      |> Sheet.set_cell("I1", "Remarks", bold: true)
      # Data
      |> Sheet.set_cell("A2", socket.assigns.customer.firstName)
      |> Sheet.set_cell("B2", socket.assigns.customer.lastName)
      |> Sheet.set_cell("C2", socket.assigns.customer.phone)
      |> Sheet.set_cell("E2", Date.to_string(socket.assigns.today))
      |> Sheet.set_cell("G2", Date.to_string(contract.checkIn))
      |> Sheet.set_cell("H2", contract.durationDay)
      |> Sheet.set_cell("I2", contract.remarks)

    %Workbook{sheets: [sheet_name]}
    |> Elixlsx.write_to(
      "db_#{socket.assigns.customer.firstName}_#{socket.assigns.customer.lastName}_DailyBooking.xlsx"
    )

    {:noreply, socket}
  end

  def handle_event("print_checkin", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  defp page_title(:show), do: "🖥️ Customer Dashboard"
  defp page_title(:edit), do: "✍🏻 แก้ไขข้อมูลลูกค้า"

  defp list_monthly_bookings(id) do
    _node =
      Tenant.list_monthly_bookings_for_customer(id)
      |> Enum.map(fn x ->
        val =
          %Booking.MonthlyBooking{}
          |> Booking.MonthlyBooking.changeset(x.properties)

        val.changes
      end)
  end

  defp list_daily_bookings(id) do
    _node =
      Tenant.list_daily_bookings_for_customer(id)
      |> Enum.map(fn x ->
        val =
          %Booking.DailyBooking{}
          |> Booking.DailyBooking.changeset(x.properties)

        val.changes
      end)
  end

  defp list_checkins(id) do
    _node =
      Tenant.list_checkins_for_customer(id)
      |> Enum.map(fn x ->
        val =
          %Booking.Checkin{}
          |> Booking.Checkin.changeset(x.properties)

        val.changes
      end)
  end

  defp list_contracts(id) do
    _node =
      Tenant.list_contracts_for_customer(id)
      |> Enum.map(fn x ->
        val =
          %Booking.Contract{}
          |> Booking.Contract.changeset(x.properties)

        val.changes
      end)
  end

  defp get_current_date() do
    _date = Date.utc_today()
  end
end

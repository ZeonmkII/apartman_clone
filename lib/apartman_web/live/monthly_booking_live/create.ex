defmodule ApartmanWeb.MonthlyBookingLive.Create do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Booking

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      assign(socket,
        page_title: "📝 จองห้องพักรายเดือน",
        customer: Tenant.get_customer!(id),
        monthlyRent: %Tenant.MonthlyRent{},
        monthlyBooking: %Booking.MonthlyBooking{},
        other_label1: "",
        other_label2: "",
        other_label3: "",
        other_label4: "",
        other_fee1: "",
        other_fee2: "",
        other_fee3: "",
        other_fee4: "",
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
          "remarks" => remarks,
          "rent_fees" => rent_fees,
          "service_fees" => service_fees,
          "deposit" => deposit,
          "advance_payment" => advance_payment,
          "keycard_fees" => keycard_fees,
          "other_labels_1" => label_1,
          "other_fees_1" => fees_1,
          "other_labels_2" => label_2,
          "other_fees_2" => fees_2,
          "other_labels_3" => label_3,
          "other_fees_3" => fees_3,
          "other_labels_4" => label_4,
          "other_fees_4" => fees_4
        },
        socket
      ) do
    # Concat each otherLabels into one big String
    other_labels = label_1 <> " & " <> label_2 <> " & " <> label_3 <> " & " <> label_4
    other_fees = fees_1 <> " + " <> fees_2 <> " + " <> fees_3 <> " + " <> fees_4
    # Needed to put something in, otherwise changeset will drop this field
    remarks = (remarks == "" && " ") || remarks

    socket =
      socket
      |> assign(
        monthlyRent: %{
          bCurrent: true,
          bTenant: true,
          bContract: true
        }
      )
      |> assign(
        monthlyBooking: %{
          remarks: remarks,
          checkIn: check_in,
          checkOut: check_out,
          advancePayment: advance_payment,
          deposit: deposit,
          rentFees: rent_fees,
          serviceFees: service_fees,
          keycardFees: keycard_fees,
          otherLabels: other_labels,
          otherFees: other_fees
        }
      )
      |> assign(
        other_label1: label_1,
        other_label2: label_2,
        other_label3: label_3,
        other_label4: label_4,
        other_fee1: fees_1,
        other_fee2: fees_2,
        other_fee3: fees_3,
        other_fee4: fees_4
      )

    {:noreply, socket}
  end

  def handle_event("submit", _session, socket) do
    {:noreply,
     socket
     |> push_redirect(
       to:
         Routes.monthly_booking_summary_path(socket, :show, %{
           id: socket.assigns.customer.uuid,
           rent: socket.assigns.monthlyRent,
           booking: socket.assigns.monthlyBooking
         })
     )}
  end
end

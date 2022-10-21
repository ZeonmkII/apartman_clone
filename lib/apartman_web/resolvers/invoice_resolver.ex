defmodule ApartmanWeb.Resolvers.InvoiceResolver do
  alias Apartman.Invoice

  def booking_fees(_parent, _args, _resolution) do
    {:ok, Invoice.list_bookingfees()}
  end

  def booking_fee(_parent, %{id: id}, _resolution) do
    {:ok, Invoice.get_booking_fee!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def daily_invoices(_parent, _args, _resolution) do
    {:ok, Invoice.list_dailyinvoices()}
  end

  def daily_invoice(_parent, %{id: id}, _resolution) do
    {:ok, Invoice.get_daily_invoice!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def monthly_invoices(_parent, _args, _resolution) do
    {:ok, Invoice.list_monthlyinvoices()}
  end

  def monthly_invoice(_parent, %{id: id}, _resolution) do
    {:ok, Invoice.get_monthly_invoice!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  defp node_to_absinthe(node) do
    if node do
      cond do
        # MonthlyInvoice node
        Map.has_key?(node, :billCycle) ->
          %{
            id: node.uuid,
            bill_cycle: node.billCycle,
            advance_payment: node.advancePayment,
            water_start: node.waterStart,
            water_end: node.waterEnd,
            water_unit: node.waterUnit,
            electric_start: node.electricStart,
            electric_end: node.electricEnd,
            other_labels: node.otherLabels,
            other_fees: node.otherFees
          }

        # DailyInvoice node
        Map.has_key?(node, :advancePayment) ->
          %{
            id: node.uuid,
            deposit: node.deposit,
            advance_payment: node.advancePayment,
            keycard_fees: node.keycardFees,
            other_labels: node.otherLabels,
            other_fees: node.otherFees
          }

        # BookingFee node
        Map.has_key?(node, :bookingFees) ->
          %{
            id: node.uuid,
            booking_fees: node.bookingFees
          }
      end
    else
      nil
    end
  end
end

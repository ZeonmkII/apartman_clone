defmodule ApartmanWeb.Schema.Types.InvoiceType do
  use Absinthe.Schema.Notation

  object :booking_fee_type do
    field :id, :string
    field :booking_fees, :float
  end

  input_object :booking_fee_input_type do
    field :parent_id, non_null(:string)
    field :booking_fees, non_null(:float)
  end

  object :daily_invoice_type do
    field :id, :string
    field :deposit, :float
    field :advance_payment, :float
    field :keycard_fees, :float
    field :other_labels, :string
    field :other_fees, :float
  end

  input_object :daily_invoice_input_type do
    field :parent_id, non_null(:string)
    field :deposit, non_null(:float)
    field :advance_payment, non_null(:float)
    field :keycard_fees, non_null(:float)
    field :other_labels, :string
    field :other_fees, :float
  end

  object :monthly_invoice_type do
    field :id, :string
    field :billCycle, :string
    field :advance_payment, :float
    field :water_start, :float
    field :water_end, :float
    field :water_unit, :float
    field :electric_start, :float
    field :electric_end, :float
    field :other_labels, :string
    field :other_fees, :float
  end

  input_object :monthly_invoice_input_type do
    field :parent_id, non_null(:string)
    field :billCycle, non_null(:string)
    field :advance_payment, non_null(:float)
    field :water_start, non_null(:float)
    field :water_end, non_null(:float)
    field :water_unit, non_null(:float)
    field :electric_start, non_null(:float)
    field :electric_end, non_null(:float)
    field :other_labels, :string
    field :other_fees, :float
  end
end

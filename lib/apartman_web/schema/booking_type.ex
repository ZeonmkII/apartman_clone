defmodule ApartmanWeb.Schema.Types.BookingType do
  use Absinthe.Schema.Notation

  object :daily_booking_type do
    field :id, :string
    field :booking_id, :string
    field :check_in, :string
    field :check_out, :string
    field :duration_day, :integer
    field :remarks, :string
  end

  input_object :daily_booking_input_type do
    field :parent_id, non_null(:string)
    field :check_in, non_null(:string)
    field :check_out, non_null(:string)
    field :remarks, :string
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  object :monthly_booking_type do
    field :id, :string
    field :booking_id, :string
    field :check_in, :string
    field :check_out, :string
    field :duration_month, :integer
    field :duration_day, :integer
    field :remarks, :string
    field :rent_fees, :float
    field :service_fees, :float
    field :deposit, :float
    field :advance_payment, :float
    field :keycard_fees, :float
    field :other_labels, :string
    field :other_fees, :float
  end

  input_object :monthly_booking_input_type do
    field :parent_id, non_null(:string)
    field :check_in, non_null(:string)
    field :check_out, non_null(:string)
    field :remarks, :string
    field :rent_fees, non_null(:float)
    field :service_fees, :float
    field :deposit, non_null(:float)
    field :advance_payment, non_null(:float)
    field :keycard_fees, non_null(:float)
    field :other_labels, :string
    field :other_fees, :float
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  object :checkin_type do
    field :id, :string
    field :check_in, :string
    field :check_out, :string
    field :time_in, :string
    field :time_out, :string
    field :duration_day, :integer
    field :room_number, :string
    field :deposit, :string
    field :from, :string
    field :to, :string
    field :remarks, :string
  end

  input_object :checkin_input_type do
    field :parent_id, non_null(:string)
    field :check_in, non_null(:string)
    field :check_out, non_null(:string)
    field :time_in, non_null(:string)
    field :time_out, :string
    field :duration_day, :integer
    field :room_number, non_null(:string)
    field :deposit, :string
    field :from, non_null(:string)
    field :to, non_null(:string)
    field :remarks, :string
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  object :contract_type do
    field :id, :string
    field :contract_id, :string
    field :date_signed, :string
    field :check_in, :string
    field :check_out, :string
    field :room_number, :string
    field :rent_fees, :float
    field :service_fees, :float
    field :duration_month, :integer
    field :duration_day, :integer
    field :deposit, :float
    field :advance_payment, :float
    field :keycard_fees, :float
    field :keycard_number, :string
    field :other_labels, :string
    field :other_fees, :float
    field :meter_water, :string
    field :meter_electric, :float
    field :remarks, :string
  end

  object :contract_input_type do
    field :parent_id, non_null(:string)
    field :date_signed, non_null(:string)
    field :check_in, non_null(:string)
    field :check_out, non_null(:string)
    field :room_number, non_null(:string)
    field :rent_fees, non_null(:float)
    field :service_fees, :float
    field :deposit, non_null(:float)
    field :advance_payment, non_null(:float)
    field :keycard_fees, non_null(:float)
    field :keycard_number, non_null(:string)
    field :other_labels, :string
    field :other_fees, :float
    field :meter_water, non_null(:string)
    field :meter_electric, non_null(:float)
    field :remarks, :string
  end
end

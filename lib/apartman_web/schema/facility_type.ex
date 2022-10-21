defmodule ApartmanWeb.Schema.Types.FacilityType do
  use Absinthe.Schema.Notation

  object :building_type do
    field :id, :string
    field :name, :string
    field :address, :string
    field :tax_id, :string
    field :phone, :string
    field :calc_type_water, :string
    field :calc_type_electric, :string
    field :unit_price_water, :string
    field :unit_price_electric, :boolean
  end

  input_object :building_input_type do
    field :name, non_null(:string)
    field :address, non_null(:string)
    field :tax_id, non_null(:string)
    field :phone, non_null(:string)
    field :calc_type_water, non_null(:string)
    field :calc_type_electric, non_null(:string)
    field :unit_price_water, non_null(:string)
    field :unit_price_electric, non_null(:boolean)
  end

  object :floor_type do
    field :id, :string
    field :number, :string
  end

  input_object :floor_input_type do
    field :number, non_null(:string)
  end

  object :room_type do
    field :id, :string
    field :number, :string
    field :b_booked, :string
    field :b_occupied, :string
  end

  input_object :room_input_type do
    field :number, non_null(:string)
    field :b_booked, :string
    field :b_occupied, :string
  end
end

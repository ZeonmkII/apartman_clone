defmodule ApartmanWeb.Resolvers.FacilityResolver do
  alias Apartman.Facility

  def buildings(_parent, _args, _resolution) do
    {:ok, Facility.list_buildings()}
  end

  def building(_parent, %{id: id}, _resolution) do
    {:ok, Facility.get_building!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def floors(_parent, _args, _resolution) do
    {:ok, Facility.list_floors()}
  end

  def floor(_parent, %{id: id}, _resolution) do
    {:ok, Facility.get_floor!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def rooms(_parent, _args, _resolution) do
    {:ok, Facility.list_rooms()}
  end

  def room(_parent, %{id: id}, _resolution) do
    {:ok, Facility.get_room!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  defp node_to_absinthe(node) do
    if node do
      cond do
        # Building node
        Map.has_key?(node, :name) ->
          %{
            id: node.uuid,
            name: node.name,
            address: node.address,
            tax_id: node.taxId,
            phone: node.phone,
            calc_type_water: node.calcTypeWater,
            calc_type_electric: node.calcTypeElectric,
            unit_price_water: node.unitPriceWater,
            unit_price_electric: node.unitPriceElectric
          }

        # Room node
        Map.has_key?(node, :bBooked) ->
          %{
            id: node.uuid,
            number: node.number,
            b_booked: node.bBooked,
            b_occupied: node.bOccupied
          }

        # Floor node
        Map.has_key?(node, :number) ->
          %{
            id: node.uuid,
            number: node.number
          }
      end
    else
      nil
    end
  end
end

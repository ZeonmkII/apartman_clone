defmodule Apartman.Facility.Building do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Facility.Floor
  alias Apartman.Facility.Relationship.HasFloor

  node "Building" do
    property(:name, :string)
    property(:address, :string)
    property(:taxId, :string)
    property(:phone, :string)
    property(:calcTypeWater, :string)
    property(:calcTypeElectric, :string)
    property(:unitPriceWater, :string)
    property(:unitPriceElectric, :string)

    outgoing_relationship(
      "HAS_FLOOR",
      Floor,
      :has,
      HasFloor,
      cardinality: :many
    )
  end

  @doc false
  def changeset(building, attrs) do
    building
    |> cast(attrs, [
      :uuid,
      :name,
      :address,
      :taxId,
      :phone,
      :calcTypeWater,
      :calcTypeElectric,
      :unitPriceWater,
      :unitPriceElectric
    ])
    |> validate_required([
      :name,
      :address,
      :taxId,
      :phone,
      :calcTypeWater,
      :calcTypeElectric,
      :unitPriceWater,
      :unitPriceElectric
    ])
  end
end

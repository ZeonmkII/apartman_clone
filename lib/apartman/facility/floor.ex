defmodule Apartman.Facility.Floor do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Facility.{Room, Building}
  alias Apartman.Facility.Relationship.{HasRoom, HasFloor}

  node "Floor" do
    property(:number, :string)

    incoming_relationship(
      "HAS_FLOOR",
      Building,
      :is_on,
      HasFloor,
      cardinality: :one
    )

    outgoing_relationship(
      "HAS_ROOM",
      Room,
      :has,
      HasRoom,
      cardinality: :many
    )
  end

  @doc false
  def changeset(floor, attrs) do
    floor
    |> cast(attrs, [:uuid, :number])
    |> validate_required([:number])
  end
end

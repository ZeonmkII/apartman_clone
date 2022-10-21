defmodule Apartman.Receipt.ContractFee do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Booking.Contract
  alias Apartman.Booking.Relationship.CreateReceipt

  node "ContractFee" do
    property(:deposit, :string)
    property(:advancePayment, :string)
    property(:keycardFees, :string)
    property(:otherLabels, :string)
    property(:otherFees, :string)

    incoming_relationship(
      "CREATE_CONTRACT_RECEIPT",
      Contract,
      :created_by,
      CreateReceipt,
      cardinality: :one
    )
  end

  @doc false
  def changeset(contract_fee, attrs) do
    contract_fee
    |> cast(attrs, [:uuid, :deposit, :advancePayment, :keycardFees, :otherLabels, :otherFees])
    |> validate_required([:deposit, :advancePayment, :keycardFees])
  end
end

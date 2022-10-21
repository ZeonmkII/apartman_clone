defmodule ApartmanWeb.Schema.Types.ReceiptType do
  use Absinthe.Schema.Notation

  object :contract_fee_type do
    field :id, :string
    field :deposit, :string
    field :advance_payment, :string
    field :keycard_fees, :string
    field :other_labels, :string
    field :other_fees, :string
  end

  input_object :contract_fee_input_type do
    field :parent_id, non_null(:string)
    field :deposit, non_null(:string)
    field :advance_payment, non_null(:string)
    field :keycard_fees, non_null(:string)
    field :other_labels, :string
    field :other_fees, :string
  end
end

defmodule ApartmanWeb.Resolvers.ReceiptResolver do
  alias Apartman.Receipt

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def contract_fees(_parent, _args, _resolution) do
    {:ok, Receipt.list_contractfees()}
  end

  def contract_fee(_parent, %{id: id}, _resolution) do
    {:ok, Receipt.get_contract_fee!(id) |> node_to_absinthe()}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  defp node_to_absinthe(node) do
    if node do
      cond do
        # Contract-Fees node
        Map.has_key?(node, :advancePayment) ->
          %{
            id: node.uuid,
            deposit: node.deposit,
            advance_payment: node.advancePayment,
            keycard_fees: node.keycardFees,
            other_labels: node.otherLabels,
            other_fees: node.otherFees
          }
      end
    else
      nil
    end
  end
end

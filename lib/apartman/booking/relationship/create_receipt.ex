defmodule Apartman.Booking.Relationship.CreateReceipt do
  use Seraph.Schema.Relationship
  import Seraph.Changeset

  @cardinality [incoming: :one, outgoing: :one]

  relationship "CREATE_CONTRACT_RECEIPT" do
    start_node(Apartman.Booking.Contract)
    end_node(Apartman.Receipt.ContractFee)

    property(:timestamp, :naive_datetime)
  end

  def changeset(wrote, params) do
    wrote
    |> cast(params, [:start_node, :end_node, :timestamp])
    |> add_timestamp()
  end

  defp add_timestamp(changeset) do
    {:ok, now} = DateTime.now("Asia/Bangkok")
    put_change(changeset, :timestamp, now)
  end
end

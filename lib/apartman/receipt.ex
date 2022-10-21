defmodule Apartman.Receipt do
  @moduledoc """
  The Receipt context.
  """

  import Ecto.Query, warn: false
  alias Apartman.Repo
  alias Bolt.Sips, as: Neo
  alias Apartman.Receipt.ContractFee

  @doc """
  Convert result from Neo4j (map) into Absinthe prefered format
  """
  def map_to_absinthe(node) do
    %{
      id: node["uuid"],
      deposit: node["deposit"],
      advance_payment: node["advancePayment"],
      keycard_fees: node["keycardFees"],
      other_labels: node["otherLabels"],
      other_fees: node["otherFees"]
    }
  end

  # **********************************************************
  # *                                                        *
  # *                  Contract Fees                         *
  # *                                                        *
  # **********************************************************

  @doc """
  Returns the list of contractfees.

  ## Examples

      iex> list_contractfees()
      [%ContractFee{}, ...]

  """
  def list_contractfees do
    conn = Neo.conn()
    query = "MATCH (c:ContractFee) WHERE NOT exists(c.delete) RETURN c AS ContractFee"
    response = Neo.query!(conn, query)

    _ContractFees =
      Enum.map(response.results, & &1["ContractFee"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single contract_fee.

  Raises `Ecto.NoResultsError` if the Contract fee does not exist.

  ## Examples

      iex> get_contract_fee!(123)
      %ContractFee{}

      iex> get_contract_fee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contract_fee!(id) do
    Repo.Node.get(ContractFee, id)
  end

  @doc """
  Creates a contract_fee.

  ## Examples

      iex> create_contract_fee(%{field: value})
      {:ok, %ContractFee{}}

      iex> create_contract_fee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contract_fee(attrs \\ %{}) do
    %ContractFee{}
    |> ContractFee.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a contract_fee.

  ## Examples

      iex> update_contract_fee(contract_fee, %{field: new_value})
      {:ok, %ContractFee{}}

      iex> update_contract_fee(contract_fee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contract_fee(%ContractFee{} = contract_fee, attrs) do
    contract_fee
    |> ContractFee.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a contract_fee.

  ## Examples

      iex> delete_contract_fee(contract_fee)
      {:ok, %ContractFee{}}

      iex> delete_contract_fee(contract_fee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contract_fee(id) do
    Repo.Node.get(ContractFee, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contract_fee changes.

  ## Examples

      iex> change_contract_fee(contract_fee)
      %Ecto.Changeset{data: %ContractFee{}}

  """
  def change_contract_fee(%ContractFee{} = contract_fee, attrs \\ %{}) do
    ContractFee.changeset(contract_fee, attrs)
  end
end

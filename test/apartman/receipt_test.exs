defmodule Apartman.ReceiptTest do
  use Apartman.DataCase

  alias Apartman.Receipt

  describe "contractfees" do
    alias Apartman.Receipt.ContractFee

    @valid_attrs %{advancePayment: "some advancePayment", deposit: "some deposit", keycardFees: "some keycardFees", otherFees: "some otherFees", otherLabels: "some otherLabels"}
    @update_attrs %{advancePayment: "some updated advancePayment", deposit: "some updated deposit", keycardFees: "some updated keycardFees", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels"}
    @invalid_attrs %{advancePayment: nil, deposit: nil, keycardFees: nil, otherFees: nil, otherLabels: nil}

    def contract_fee_fixture(attrs \\ %{}) do
      {:ok, contract_fee} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Receipt.create_contract_fee()

      contract_fee
    end

    test "list_contractfees/0 returns all contractfees" do
      contract_fee = contract_fee_fixture()
      assert Receipt.list_contractfees() == [contract_fee]
    end

    test "get_contract_fee!/1 returns the contract_fee with given id" do
      contract_fee = contract_fee_fixture()
      assert Receipt.get_contract_fee!(contract_fee.id) == contract_fee
    end

    test "create_contract_fee/1 with valid data creates a contract_fee" do
      assert {:ok, %ContractFee{} = contract_fee} = Receipt.create_contract_fee(@valid_attrs)
      assert contract_fee.advancePayment == "some advancePayment"
      assert contract_fee.deposit == "some deposit"
      assert contract_fee.keycardFees == "some keycardFees"
      assert contract_fee.otherFees == "some otherFees"
      assert contract_fee.otherLabels == "some otherLabels"
    end

    test "create_contract_fee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Receipt.create_contract_fee(@invalid_attrs)
    end

    test "update_contract_fee/2 with valid data updates the contract_fee" do
      contract_fee = contract_fee_fixture()
      assert {:ok, %ContractFee{} = contract_fee} = Receipt.update_contract_fee(contract_fee, @update_attrs)
      assert contract_fee.advancePayment == "some updated advancePayment"
      assert contract_fee.deposit == "some updated deposit"
      assert contract_fee.keycardFees == "some updated keycardFees"
      assert contract_fee.otherFees == "some updated otherFees"
      assert contract_fee.otherLabels == "some updated otherLabels"
    end

    test "update_contract_fee/2 with invalid data returns error changeset" do
      contract_fee = contract_fee_fixture()
      assert {:error, %Ecto.Changeset{}} = Receipt.update_contract_fee(contract_fee, @invalid_attrs)
      assert contract_fee == Receipt.get_contract_fee!(contract_fee.id)
    end

    test "delete_contract_fee/1 deletes the contract_fee" do
      contract_fee = contract_fee_fixture()
      assert {:ok, %ContractFee{}} = Receipt.delete_contract_fee(contract_fee)
      assert_raise Ecto.NoResultsError, fn -> Receipt.get_contract_fee!(contract_fee.id) end
    end

    test "change_contract_fee/1 returns a contract_fee changeset" do
      contract_fee = contract_fee_fixture()
      assert %Ecto.Changeset{} = Receipt.change_contract_fee(contract_fee)
    end
  end
end

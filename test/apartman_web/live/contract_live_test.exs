defmodule ApartmanWeb.ContractLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Booking

  @create_attrs %{advancePayment: "some advancePayment", checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], contractId: "some contractId", dateSigned: ~D[2010-04-17], deposit: "some deposit", durationDay: 42, durationMonth: 42, keycardFees: "some keycardFees", keycardNumber: "some keycardNumber", meterElectric: 120.5, meterWater: 120.5, otherFees: "some otherFees", otherLabels: "some otherLabels", remarks: "some remarks", rentFees: "some rentFees", roomNumber: "some roomNumber", serviceFees: "some serviceFees"}
  @update_attrs %{advancePayment: "some updated advancePayment", checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], contractId: "some updated contractId", dateSigned: ~D[2011-05-18], deposit: "some updated deposit", durationDay: 43, durationMonth: 43, keycardFees: "some updated keycardFees", keycardNumber: "some updated keycardNumber", meterElectric: 456.7, meterWater: 456.7, otherFees: "some updated otherFees", otherLabels: "some updated otherLabels", remarks: "some updated remarks", rentFees: "some updated rentFees", roomNumber: "some updated roomNumber", serviceFees: "some updated serviceFees"}
  @invalid_attrs %{advancePayment: nil, checkIn: nil, checkOut: nil, contractId: nil, dateSigned: nil, deposit: nil, durationDay: nil, durationMonth: nil, keycardFees: nil, keycardNumber: nil, meterElectric: nil, meterWater: nil, otherFees: nil, otherLabels: nil, remarks: nil, rentFees: nil, roomNumber: nil, serviceFees: nil}

  defp fixture(:contract) do
    {:ok, contract} = Booking.create_contract(@create_attrs)
    contract
  end

  defp create_contract(_) do
    contract = fixture(:contract)
    %{contract: contract}
  end

  describe "Index" do
    setup [:create_contract]

    test "lists all contracts", %{conn: conn, contract: contract} do
      {:ok, _index_live, html} = live(conn, Routes.contract_index_path(conn, :index))

      assert html =~ "Listing Contracts"
      assert html =~ contract.advancePayment
    end

    test "saves new contract", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.contract_index_path(conn, :index))

      assert index_live |> element("a", "New Contract") |> render_click() =~
               "New Contract"

      assert_patch(index_live, Routes.contract_index_path(conn, :new))

      assert index_live
             |> form("#contract-form", contract: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#contract-form", contract: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contract_index_path(conn, :index))

      assert html =~ "Contract created successfully"
      assert html =~ "some advancePayment"
    end

    test "updates contract in listing", %{conn: conn, contract: contract} do
      {:ok, index_live, _html} = live(conn, Routes.contract_index_path(conn, :index))

      assert index_live |> element("#contract-#{contract.id} a", "Edit") |> render_click() =~
               "Edit Contract"

      assert_patch(index_live, Routes.contract_index_path(conn, :edit, contract))

      assert index_live
             |> form("#contract-form", contract: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#contract-form", contract: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contract_index_path(conn, :index))

      assert html =~ "Contract updated successfully"
      assert html =~ "some updated advancePayment"
    end

    test "deletes contract in listing", %{conn: conn, contract: contract} do
      {:ok, index_live, _html} = live(conn, Routes.contract_index_path(conn, :index))

      assert index_live |> element("#contract-#{contract.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#contract-#{contract.id}")
    end
  end

  describe "Show" do
    setup [:create_contract]

    test "displays contract", %{conn: conn, contract: contract} do
      {:ok, _show_live, html} = live(conn, Routes.contract_show_path(conn, :show, contract))

      assert html =~ "Show Contract"
      assert html =~ contract.advancePayment
    end

    test "updates contract within modal", %{conn: conn, contract: contract} do
      {:ok, show_live, _html} = live(conn, Routes.contract_show_path(conn, :show, contract))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Contract"

      assert_patch(show_live, Routes.contract_show_path(conn, :edit, contract))

      assert show_live
             |> form("#contract-form", contract: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#contract-form", contract: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contract_show_path(conn, :show, contract))

      assert html =~ "Contract updated successfully"
      assert html =~ "some updated advancePayment"
    end
  end
end

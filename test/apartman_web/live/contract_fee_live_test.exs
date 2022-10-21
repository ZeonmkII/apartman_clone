defmodule ApartmanWeb.ContractFeeLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Receipt

  @create_attrs %{advancePayment: "some advancePayment", deposit: "some deposit", keycardFees: "some keycardFees", otherFees: "some otherFees", otherLabels: "some otherLabels"}
  @update_attrs %{advancePayment: "some updated advancePayment", deposit: "some updated deposit", keycardFees: "some updated keycardFees", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels"}
  @invalid_attrs %{advancePayment: nil, deposit: nil, keycardFees: nil, otherFees: nil, otherLabels: nil}

  defp fixture(:contract_fee) do
    {:ok, contract_fee} = Receipt.create_contract_fee(@create_attrs)
    contract_fee
  end

  defp create_contract_fee(_) do
    contract_fee = fixture(:contract_fee)
    %{contract_fee: contract_fee}
  end

  describe "Index" do
    setup [:create_contract_fee]

    test "lists all contractfees", %{conn: conn, contract_fee: contract_fee} do
      {:ok, _index_live, html} = live(conn, Routes.contract_fee_index_path(conn, :index))

      assert html =~ "Listing Contractfees"
      assert html =~ contract_fee.advancePayment
    end

    test "saves new contract_fee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.contract_fee_index_path(conn, :index))

      assert index_live |> element("a", "New Contract fee") |> render_click() =~
               "New Contract fee"

      assert_patch(index_live, Routes.contract_fee_index_path(conn, :new))

      assert index_live
             |> form("#contract_fee-form", contract_fee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#contract_fee-form", contract_fee: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contract_fee_index_path(conn, :index))

      assert html =~ "Contract fee created successfully"
      assert html =~ "some advancePayment"
    end

    test "updates contract_fee in listing", %{conn: conn, contract_fee: contract_fee} do
      {:ok, index_live, _html} = live(conn, Routes.contract_fee_index_path(conn, :index))

      assert index_live |> element("#contract_fee-#{contract_fee.id} a", "Edit") |> render_click() =~
               "Edit Contract fee"

      assert_patch(index_live, Routes.contract_fee_index_path(conn, :edit, contract_fee))

      assert index_live
             |> form("#contract_fee-form", contract_fee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#contract_fee-form", contract_fee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contract_fee_index_path(conn, :index))

      assert html =~ "Contract fee updated successfully"
      assert html =~ "some updated advancePayment"
    end

    test "deletes contract_fee in listing", %{conn: conn, contract_fee: contract_fee} do
      {:ok, index_live, _html} = live(conn, Routes.contract_fee_index_path(conn, :index))

      assert index_live |> element("#contract_fee-#{contract_fee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#contract_fee-#{contract_fee.id}")
    end
  end

  describe "Show" do
    setup [:create_contract_fee]

    test "displays contract_fee", %{conn: conn, contract_fee: contract_fee} do
      {:ok, _show_live, html} = live(conn, Routes.contract_fee_show_path(conn, :show, contract_fee))

      assert html =~ "Show Contract fee"
      assert html =~ contract_fee.advancePayment
    end

    test "updates contract_fee within modal", %{conn: conn, contract_fee: contract_fee} do
      {:ok, show_live, _html} = live(conn, Routes.contract_fee_show_path(conn, :show, contract_fee))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Contract fee"

      assert_patch(show_live, Routes.contract_fee_show_path(conn, :edit, contract_fee))

      assert show_live
             |> form("#contract_fee-form", contract_fee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#contract_fee-form", contract_fee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contract_fee_show_path(conn, :show, contract_fee))

      assert html =~ "Contract fee updated successfully"
      assert html =~ "some updated advancePayment"
    end
  end
end

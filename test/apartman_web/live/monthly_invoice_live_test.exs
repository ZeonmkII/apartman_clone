defmodule ApartmanWeb.MonthlyInvoiceLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Invoice

  @create_attrs %{advancePayment: "some advancePayment", billCycle: ~D[2010-04-17], electricStart: "some electricStart", eletricEnd: "some eletricEnd", otherFees: "some otherFees", otherLabels: "some otherLabels", waterEnd: "some waterEnd", waterStart: "some waterStart", waterUnit: "some waterUnit"}
  @update_attrs %{advancePayment: "some updated advancePayment", billCycle: ~D[2011-05-18], electricStart: "some updated electricStart", eletricEnd: "some updated eletricEnd", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels", waterEnd: "some updated waterEnd", waterStart: "some updated waterStart", waterUnit: "some updated waterUnit"}
  @invalid_attrs %{advancePayment: nil, billCycle: nil, electricStart: nil, eletricEnd: nil, otherFees: nil, otherLabels: nil, waterEnd: nil, waterStart: nil, waterUnit: nil}

  defp fixture(:monthly_invoice) do
    {:ok, monthly_invoice} = Invoice.create_monthly_invoice(@create_attrs)
    monthly_invoice
  end

  defp create_monthly_invoice(_) do
    monthly_invoice = fixture(:monthly_invoice)
    %{monthly_invoice: monthly_invoice}
  end

  describe "Index" do
    setup [:create_monthly_invoice]

    test "lists all monthlyinvoices", %{conn: conn, monthly_invoice: monthly_invoice} do
      {:ok, _index_live, html} = live(conn, Routes.monthly_invoice_index_path(conn, :index))

      assert html =~ "Listing Monthlyinvoices"
      assert html =~ monthly_invoice.advancePayment
    end

    test "saves new monthly_invoice", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_invoice_index_path(conn, :index))

      assert index_live |> element("a", "New Monthly invoice") |> render_click() =~
               "New Monthly invoice"

      assert_patch(index_live, Routes.monthly_invoice_index_path(conn, :new))

      assert index_live
             |> form("#monthly_invoice-form", monthly_invoice: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#monthly_invoice-form", monthly_invoice: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_invoice_index_path(conn, :index))

      assert html =~ "Monthly invoice created successfully"
      assert html =~ "some advancePayment"
    end

    test "updates monthly_invoice in listing", %{conn: conn, monthly_invoice: monthly_invoice} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_invoice_index_path(conn, :index))

      assert index_live |> element("#monthly_invoice-#{monthly_invoice.id} a", "Edit") |> render_click() =~
               "Edit Monthly invoice"

      assert_patch(index_live, Routes.monthly_invoice_index_path(conn, :edit, monthly_invoice))

      assert index_live
             |> form("#monthly_invoice-form", monthly_invoice: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#monthly_invoice-form", monthly_invoice: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_invoice_index_path(conn, :index))

      assert html =~ "Monthly invoice updated successfully"
      assert html =~ "some updated advancePayment"
    end

    test "deletes monthly_invoice in listing", %{conn: conn, monthly_invoice: monthly_invoice} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_invoice_index_path(conn, :index))

      assert index_live |> element("#monthly_invoice-#{monthly_invoice.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#monthly_invoice-#{monthly_invoice.id}")
    end
  end

  describe "Show" do
    setup [:create_monthly_invoice]

    test "displays monthly_invoice", %{conn: conn, monthly_invoice: monthly_invoice} do
      {:ok, _show_live, html} = live(conn, Routes.monthly_invoice_show_path(conn, :show, monthly_invoice))

      assert html =~ "Show Monthly invoice"
      assert html =~ monthly_invoice.advancePayment
    end

    test "updates monthly_invoice within modal", %{conn: conn, monthly_invoice: monthly_invoice} do
      {:ok, show_live, _html} = live(conn, Routes.monthly_invoice_show_path(conn, :show, monthly_invoice))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Monthly invoice"

      assert_patch(show_live, Routes.monthly_invoice_show_path(conn, :edit, monthly_invoice))

      assert show_live
             |> form("#monthly_invoice-form", monthly_invoice: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#monthly_invoice-form", monthly_invoice: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_invoice_show_path(conn, :show, monthly_invoice))

      assert html =~ "Monthly invoice updated successfully"
      assert html =~ "some updated advancePayment"
    end
  end
end

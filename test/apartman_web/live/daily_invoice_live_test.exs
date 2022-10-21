defmodule ApartmanWeb.DailyInvoiceLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Invoice

  @create_attrs %{advancePayment: "some advancePayment", deposit: "some deposit", keycardFees: "some keycardFees", otherFees: "some otherFees", otherLabels: "some otherLabels"}
  @update_attrs %{advancePayment: "some updated advancePayment", deposit: "some updated deposit", keycardFees: "some updated keycardFees", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels"}
  @invalid_attrs %{advancePayment: nil, deposit: nil, keycardFees: nil, otherFees: nil, otherLabels: nil}

  defp fixture(:daily_invoice) do
    {:ok, daily_invoice} = Invoice.create_daily_invoice(@create_attrs)
    daily_invoice
  end

  defp create_daily_invoice(_) do
    daily_invoice = fixture(:daily_invoice)
    %{daily_invoice: daily_invoice}
  end

  describe "Index" do
    setup [:create_daily_invoice]

    test "lists all dailyinvoices", %{conn: conn, daily_invoice: daily_invoice} do
      {:ok, _index_live, html} = live(conn, Routes.daily_invoice_index_path(conn, :index))

      assert html =~ "Listing Dailyinvoices"
      assert html =~ daily_invoice.advancePayment
    end

    test "saves new daily_invoice", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.daily_invoice_index_path(conn, :index))

      assert index_live |> element("a", "New Daily invoice") |> render_click() =~
               "New Daily invoice"

      assert_patch(index_live, Routes.daily_invoice_index_path(conn, :new))

      assert index_live
             |> form("#daily_invoice-form", daily_invoice: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#daily_invoice-form", daily_invoice: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_invoice_index_path(conn, :index))

      assert html =~ "Daily invoice created successfully"
      assert html =~ "some advancePayment"
    end

    test "updates daily_invoice in listing", %{conn: conn, daily_invoice: daily_invoice} do
      {:ok, index_live, _html} = live(conn, Routes.daily_invoice_index_path(conn, :index))

      assert index_live |> element("#daily_invoice-#{daily_invoice.id} a", "Edit") |> render_click() =~
               "Edit Daily invoice"

      assert_patch(index_live, Routes.daily_invoice_index_path(conn, :edit, daily_invoice))

      assert index_live
             |> form("#daily_invoice-form", daily_invoice: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#daily_invoice-form", daily_invoice: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_invoice_index_path(conn, :index))

      assert html =~ "Daily invoice updated successfully"
      assert html =~ "some updated advancePayment"
    end

    test "deletes daily_invoice in listing", %{conn: conn, daily_invoice: daily_invoice} do
      {:ok, index_live, _html} = live(conn, Routes.daily_invoice_index_path(conn, :index))

      assert index_live |> element("#daily_invoice-#{daily_invoice.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#daily_invoice-#{daily_invoice.id}")
    end
  end

  describe "Show" do
    setup [:create_daily_invoice]

    test "displays daily_invoice", %{conn: conn, daily_invoice: daily_invoice} do
      {:ok, _show_live, html} = live(conn, Routes.daily_invoice_show_path(conn, :show, daily_invoice))

      assert html =~ "Show Daily invoice"
      assert html =~ daily_invoice.advancePayment
    end

    test "updates daily_invoice within modal", %{conn: conn, daily_invoice: daily_invoice} do
      {:ok, show_live, _html} = live(conn, Routes.daily_invoice_show_path(conn, :show, daily_invoice))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Daily invoice"

      assert_patch(show_live, Routes.daily_invoice_show_path(conn, :edit, daily_invoice))

      assert show_live
             |> form("#daily_invoice-form", daily_invoice: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#daily_invoice-form", daily_invoice: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_invoice_show_path(conn, :show, daily_invoice))

      assert html =~ "Daily invoice updated successfully"
      assert html =~ "some updated advancePayment"
    end
  end
end

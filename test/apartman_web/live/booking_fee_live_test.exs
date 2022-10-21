defmodule ApartmanWeb.BookingFeeLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Invoice

  @create_attrs %{bookingFees: "some bookingFees"}
  @update_attrs %{bookingFees: "some updated bookingFees"}
  @invalid_attrs %{bookingFees: nil}

  defp fixture(:booking_fee) do
    {:ok, booking_fee} = Invoice.create_booking_fee(@create_attrs)
    booking_fee
  end

  defp create_booking_fee(_) do
    booking_fee = fixture(:booking_fee)
    %{booking_fee: booking_fee}
  end

  describe "Index" do
    setup [:create_booking_fee]

    test "lists all bookingfees", %{conn: conn, booking_fee: booking_fee} do
      {:ok, _index_live, html} = live(conn, Routes.booking_fee_index_path(conn, :index))

      assert html =~ "Listing Bookingfees"
      assert html =~ booking_fee.bookingFees
    end

    test "saves new booking_fee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.booking_fee_index_path(conn, :index))

      assert index_live |> element("a", "New Booking fee") |> render_click() =~
               "New Booking fee"

      assert_patch(index_live, Routes.booking_fee_index_path(conn, :new))

      assert index_live
             |> form("#booking_fee-form", booking_fee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#booking_fee-form", booking_fee: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.booking_fee_index_path(conn, :index))

      assert html =~ "Booking fee created successfully"
      assert html =~ "some bookingFees"
    end

    test "updates booking_fee in listing", %{conn: conn, booking_fee: booking_fee} do
      {:ok, index_live, _html} = live(conn, Routes.booking_fee_index_path(conn, :index))

      assert index_live |> element("#booking_fee-#{booking_fee.id} a", "Edit") |> render_click() =~
               "Edit Booking fee"

      assert_patch(index_live, Routes.booking_fee_index_path(conn, :edit, booking_fee))

      assert index_live
             |> form("#booking_fee-form", booking_fee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#booking_fee-form", booking_fee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.booking_fee_index_path(conn, :index))

      assert html =~ "Booking fee updated successfully"
      assert html =~ "some updated bookingFees"
    end

    test "deletes booking_fee in listing", %{conn: conn, booking_fee: booking_fee} do
      {:ok, index_live, _html} = live(conn, Routes.booking_fee_index_path(conn, :index))

      assert index_live |> element("#booking_fee-#{booking_fee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#booking_fee-#{booking_fee.id}")
    end
  end

  describe "Show" do
    setup [:create_booking_fee]

    test "displays booking_fee", %{conn: conn, booking_fee: booking_fee} do
      {:ok, _show_live, html} = live(conn, Routes.booking_fee_show_path(conn, :show, booking_fee))

      assert html =~ "Show Booking fee"
      assert html =~ booking_fee.bookingFees
    end

    test "updates booking_fee within modal", %{conn: conn, booking_fee: booking_fee} do
      {:ok, show_live, _html} = live(conn, Routes.booking_fee_show_path(conn, :show, booking_fee))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Booking fee"

      assert_patch(show_live, Routes.booking_fee_show_path(conn, :edit, booking_fee))

      assert show_live
             |> form("#booking_fee-form", booking_fee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#booking_fee-form", booking_fee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.booking_fee_show_path(conn, :show, booking_fee))

      assert html =~ "Booking fee updated successfully"
      assert html =~ "some updated bookingFees"
    end
  end
end

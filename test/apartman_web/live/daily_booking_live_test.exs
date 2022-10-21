defmodule ApartmanWeb.DailyBookingLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Booking

  @create_attrs %{bookingId: "some bookingId", checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], durationDay: 42, remarks: "some remarks"}
  @update_attrs %{bookingId: "some updated bookingId", checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], durationDay: 43, remarks: "some updated remarks"}
  @invalid_attrs %{bookingId: nil, checkIn: nil, checkOut: nil, durationDay: nil, remarks: nil}

  defp fixture(:daily_booking) do
    {:ok, daily_booking} = Booking.create_daily_booking(@create_attrs)
    daily_booking
  end

  defp create_daily_booking(_) do
    daily_booking = fixture(:daily_booking)
    %{daily_booking: daily_booking}
  end

  describe "Index" do
    setup [:create_daily_booking]

    test "lists all dailybookings", %{conn: conn, daily_booking: daily_booking} do
      {:ok, _index_live, html} = live(conn, Routes.daily_booking_index_path(conn, :index))

      assert html =~ "Listing Dailybookings"
      assert html =~ daily_booking.bookingId
    end

    test "saves new daily_booking", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.daily_booking_index_path(conn, :index))

      assert index_live |> element("a", "New Daily booking") |> render_click() =~
               "New Daily booking"

      assert_patch(index_live, Routes.daily_booking_index_path(conn, :new))

      assert index_live
             |> form("#daily_booking-form", daily_booking: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#daily_booking-form", daily_booking: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_booking_index_path(conn, :index))

      assert html =~ "Daily booking created successfully"
      assert html =~ "some bookingId"
    end

    test "updates daily_booking in listing", %{conn: conn, daily_booking: daily_booking} do
      {:ok, index_live, _html} = live(conn, Routes.daily_booking_index_path(conn, :index))

      assert index_live |> element("#daily_booking-#{daily_booking.id} a", "Edit") |> render_click() =~
               "Edit Daily booking"

      assert_patch(index_live, Routes.daily_booking_index_path(conn, :edit, daily_booking))

      assert index_live
             |> form("#daily_booking-form", daily_booking: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#daily_booking-form", daily_booking: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_booking_index_path(conn, :index))

      assert html =~ "Daily booking updated successfully"
      assert html =~ "some updated bookingId"
    end

    test "deletes daily_booking in listing", %{conn: conn, daily_booking: daily_booking} do
      {:ok, index_live, _html} = live(conn, Routes.daily_booking_index_path(conn, :index))

      assert index_live |> element("#daily_booking-#{daily_booking.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#daily_booking-#{daily_booking.id}")
    end
  end

  describe "Show" do
    setup [:create_daily_booking]

    test "displays daily_booking", %{conn: conn, daily_booking: daily_booking} do
      {:ok, _show_live, html} = live(conn, Routes.daily_booking_show_path(conn, :show, daily_booking))

      assert html =~ "Show Daily booking"
      assert html =~ daily_booking.bookingId
    end

    test "updates daily_booking within modal", %{conn: conn, daily_booking: daily_booking} do
      {:ok, show_live, _html} = live(conn, Routes.daily_booking_show_path(conn, :show, daily_booking))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Daily booking"

      assert_patch(show_live, Routes.daily_booking_show_path(conn, :edit, daily_booking))

      assert show_live
             |> form("#daily_booking-form", daily_booking: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#daily_booking-form", daily_booking: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_booking_show_path(conn, :show, daily_booking))

      assert html =~ "Daily booking updated successfully"
      assert html =~ "some updated bookingId"
    end
  end
end

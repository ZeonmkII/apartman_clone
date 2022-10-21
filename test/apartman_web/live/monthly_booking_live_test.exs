defmodule ApartmanWeb.MonthlyBookingLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Booking

  @create_attrs %{advancePayment: "some advancePayment", bookingId: "some bookingId", checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], deposit: "some deposit", durationDay: 42, durationMonth: 42, keycardFees: "some keycardFees", otherFees: "some otherFees", otherLabels: "some otherLabels", remarks: "some remarks", rentFees: "some rentFees", serviceFees: "some serviceFees"}
  @update_attrs %{advancePayment: "some updated advancePayment", bookingId: "some updated bookingId", checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], deposit: "some updated deposit", durationDay: 43, durationMonth: 43, keycardFees: "some updated keycardFees", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels", remarks: "some updated remarks", rentFees: "some updated rentFees", serviceFees: "some updated serviceFees"}
  @invalid_attrs %{advancePayment: nil, bookingId: nil, checkIn: nil, checkOut: nil, deposit: nil, durationDay: nil, durationMonth: nil, keycardFees: nil, otherFees: nil, otherLabels: nil, remarks: nil, rentFees: nil, serviceFees: nil}

  defp fixture(:monthly_booking) do
    {:ok, monthly_booking} = Booking.create_monthly_booking(@create_attrs)
    monthly_booking
  end

  defp create_monthly_booking(_) do
    monthly_booking = fixture(:monthly_booking)
    %{monthly_booking: monthly_booking}
  end

  describe "Index" do
    setup [:create_monthly_booking]

    test "lists all monthlybookings", %{conn: conn, monthly_booking: monthly_booking} do
      {:ok, _index_live, html} = live(conn, Routes.monthly_booking_index_path(conn, :index))

      assert html =~ "Listing Monthlybookings"
      assert html =~ monthly_booking.advancePayment
    end

    test "saves new monthly_booking", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_booking_index_path(conn, :index))

      assert index_live |> element("a", "New Monthly booking") |> render_click() =~
               "New Monthly booking"

      assert_patch(index_live, Routes.monthly_booking_index_path(conn, :new))

      assert index_live
             |> form("#monthly_booking-form", monthly_booking: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#monthly_booking-form", monthly_booking: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_booking_index_path(conn, :index))

      assert html =~ "Monthly booking created successfully"
      assert html =~ "some advancePayment"
    end

    test "updates monthly_booking in listing", %{conn: conn, monthly_booking: monthly_booking} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_booking_index_path(conn, :index))

      assert index_live |> element("#monthly_booking-#{monthly_booking.id} a", "Edit") |> render_click() =~
               "Edit Monthly booking"

      assert_patch(index_live, Routes.monthly_booking_index_path(conn, :edit, monthly_booking))

      assert index_live
             |> form("#monthly_booking-form", monthly_booking: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#monthly_booking-form", monthly_booking: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_booking_index_path(conn, :index))

      assert html =~ "Monthly booking updated successfully"
      assert html =~ "some updated advancePayment"
    end

    test "deletes monthly_booking in listing", %{conn: conn, monthly_booking: monthly_booking} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_booking_index_path(conn, :index))

      assert index_live |> element("#monthly_booking-#{monthly_booking.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#monthly_booking-#{monthly_booking.id}")
    end
  end

  describe "Show" do
    setup [:create_monthly_booking]

    test "displays monthly_booking", %{conn: conn, monthly_booking: monthly_booking} do
      {:ok, _show_live, html} = live(conn, Routes.monthly_booking_show_path(conn, :show, monthly_booking))

      assert html =~ "Show Monthly booking"
      assert html =~ monthly_booking.advancePayment
    end

    test "updates monthly_booking within modal", %{conn: conn, monthly_booking: monthly_booking} do
      {:ok, show_live, _html} = live(conn, Routes.monthly_booking_show_path(conn, :show, monthly_booking))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Monthly booking"

      assert_patch(show_live, Routes.monthly_booking_show_path(conn, :edit, monthly_booking))

      assert show_live
             |> form("#monthly_booking-form", monthly_booking: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#monthly_booking-form", monthly_booking: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_booking_show_path(conn, :show, monthly_booking))

      assert html =~ "Monthly booking updated successfully"
      assert html =~ "some updated advancePayment"
    end
  end
end

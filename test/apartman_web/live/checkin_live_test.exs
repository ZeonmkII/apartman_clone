defmodule ApartmanWeb.CheckinLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Booking

  @create_attrs %{checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], deposit: "some deposit", durationDay: 42, from: "some from", remarks: "some remarks", roomNumber: "some roomNumber", timeIn: ~T[14:00:00], timeOut: ~T[14:00:00], to: "some to"}
  @update_attrs %{checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], deposit: "some updated deposit", durationDay: 43, from: "some updated from", remarks: "some updated remarks", roomNumber: "some updated roomNumber", timeIn: ~T[15:01:01], timeOut: ~T[15:01:01], to: "some updated to"}
  @invalid_attrs %{checkIn: nil, checkOut: nil, deposit: nil, durationDay: nil, from: nil, remarks: nil, roomNumber: nil, timeIn: nil, timeOut: nil, to: nil}

  defp fixture(:checkin) do
    {:ok, checkin} = Booking.create_checkin(@create_attrs)
    checkin
  end

  defp create_checkin(_) do
    checkin = fixture(:checkin)
    %{checkin: checkin}
  end

  describe "Index" do
    setup [:create_checkin]

    test "lists all checkins", %{conn: conn, checkin: checkin} do
      {:ok, _index_live, html} = live(conn, Routes.checkin_index_path(conn, :index))

      assert html =~ "Listing Checkins"
      assert html =~ checkin.deposit
    end

    test "saves new checkin", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.checkin_index_path(conn, :index))

      assert index_live |> element("a", "New Checkin") |> render_click() =~
               "New Checkin"

      assert_patch(index_live, Routes.checkin_index_path(conn, :new))

      assert index_live
             |> form("#checkin-form", checkin: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#checkin-form", checkin: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.checkin_index_path(conn, :index))

      assert html =~ "Checkin created successfully"
      assert html =~ "some deposit"
    end

    test "updates checkin in listing", %{conn: conn, checkin: checkin} do
      {:ok, index_live, _html} = live(conn, Routes.checkin_index_path(conn, :index))

      assert index_live |> element("#checkin-#{checkin.id} a", "Edit") |> render_click() =~
               "Edit Checkin"

      assert_patch(index_live, Routes.checkin_index_path(conn, :edit, checkin))

      assert index_live
             |> form("#checkin-form", checkin: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#checkin-form", checkin: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.checkin_index_path(conn, :index))

      assert html =~ "Checkin updated successfully"
      assert html =~ "some updated deposit"
    end

    test "deletes checkin in listing", %{conn: conn, checkin: checkin} do
      {:ok, index_live, _html} = live(conn, Routes.checkin_index_path(conn, :index))

      assert index_live |> element("#checkin-#{checkin.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#checkin-#{checkin.id}")
    end
  end

  describe "Show" do
    setup [:create_checkin]

    test "displays checkin", %{conn: conn, checkin: checkin} do
      {:ok, _show_live, html} = live(conn, Routes.checkin_show_path(conn, :show, checkin))

      assert html =~ "Show Checkin"
      assert html =~ checkin.deposit
    end

    test "updates checkin within modal", %{conn: conn, checkin: checkin} do
      {:ok, show_live, _html} = live(conn, Routes.checkin_show_path(conn, :show, checkin))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Checkin"

      assert_patch(show_live, Routes.checkin_show_path(conn, :edit, checkin))

      assert show_live
             |> form("#checkin-form", checkin: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#checkin-form", checkin: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.checkin_show_path(conn, :show, checkin))

      assert html =~ "Checkin updated successfully"
      assert html =~ "some updated deposit"
    end
  end
end

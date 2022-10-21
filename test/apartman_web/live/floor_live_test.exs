defmodule ApartmanWeb.FloorLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Facility

  @create_attrs %{number: "some number"}
  @update_attrs %{number: "some updated number"}
  @invalid_attrs %{number: nil}

  defp fixture(:floor) do
    {:ok, floor} = Facility.create_floor(@create_attrs)
    floor
  end

  defp create_floor(_) do
    floor = fixture(:floor)
    %{floor: floor}
  end

  describe "Index" do
    setup [:create_floor]

    test "lists all floors", %{conn: conn, floor: floor} do
      {:ok, _index_live, html} = live(conn, Routes.floor_index_path(conn, :index))

      assert html =~ "Listing Floors"
      assert html =~ floor.number
    end

    test "saves new floor", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.floor_index_path(conn, :index))

      assert index_live |> element("a", "New Floor") |> render_click() =~
               "New Floor"

      assert_patch(index_live, Routes.floor_index_path(conn, :new))

      assert index_live
             |> form("#floor-form", floor: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#floor-form", floor: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.floor_index_path(conn, :index))

      assert html =~ "Floor created successfully"
      assert html =~ "some number"
    end

    test "updates floor in listing", %{conn: conn, floor: floor} do
      {:ok, index_live, _html} = live(conn, Routes.floor_index_path(conn, :index))

      assert index_live |> element("#floor-#{floor.id} a", "Edit") |> render_click() =~
               "Edit Floor"

      assert_patch(index_live, Routes.floor_index_path(conn, :edit, floor))

      assert index_live
             |> form("#floor-form", floor: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#floor-form", floor: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.floor_index_path(conn, :index))

      assert html =~ "Floor updated successfully"
      assert html =~ "some updated number"
    end

    test "deletes floor in listing", %{conn: conn, floor: floor} do
      {:ok, index_live, _html} = live(conn, Routes.floor_index_path(conn, :index))

      assert index_live |> element("#floor-#{floor.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#floor-#{floor.id}")
    end
  end

  describe "Show" do
    setup [:create_floor]

    test "displays floor", %{conn: conn, floor: floor} do
      {:ok, _show_live, html} = live(conn, Routes.floor_show_path(conn, :show, floor))

      assert html =~ "Show Floor"
      assert html =~ floor.number
    end

    test "updates floor within modal", %{conn: conn, floor: floor} do
      {:ok, show_live, _html} = live(conn, Routes.floor_show_path(conn, :show, floor))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Floor"

      assert_patch(show_live, Routes.floor_show_path(conn, :edit, floor))

      assert show_live
             |> form("#floor-form", floor: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#floor-form", floor: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.floor_show_path(conn, :show, floor))

      assert html =~ "Floor updated successfully"
      assert html =~ "some updated number"
    end
  end
end

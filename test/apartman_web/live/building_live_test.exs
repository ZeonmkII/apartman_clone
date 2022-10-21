defmodule ApartmanWeb.BuildingLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Facility

  @create_attrs %{address: "some address", calcTypeElectric: "some calcTypeElectric", calcTypeWater: "some calcTypeWater", name: "some name", phone: "some phone", taxId: "some taxId", unitPriceElectric: "some unitPriceElectric", unitPriceWater: "some unitPriceWater"}
  @update_attrs %{address: "some updated address", calcTypeElectric: "some updated calcTypeElectric", calcTypeWater: "some updated calcTypeWater", name: "some updated name", phone: "some updated phone", taxId: "some updated taxId", unitPriceElectric: "some updated unitPriceElectric", unitPriceWater: "some updated unitPriceWater"}
  @invalid_attrs %{address: nil, calcTypeElectric: nil, calcTypeWater: nil, name: nil, phone: nil, taxId: nil, unitPriceElectric: nil, unitPriceWater: nil}

  defp fixture(:building) do
    {:ok, building} = Facility.create_building(@create_attrs)
    building
  end

  defp create_building(_) do
    building = fixture(:building)
    %{building: building}
  end

  describe "Index" do
    setup [:create_building]

    test "lists all buildings", %{conn: conn, building: building} do
      {:ok, _index_live, html} = live(conn, Routes.building_index_path(conn, :index))

      assert html =~ "Listing Buildings"
      assert html =~ building.address
    end

    test "saves new building", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.building_index_path(conn, :index))

      assert index_live |> element("a", "New Building") |> render_click() =~
               "New Building"

      assert_patch(index_live, Routes.building_index_path(conn, :new))

      assert index_live
             |> form("#building-form", building: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#building-form", building: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.building_index_path(conn, :index))

      assert html =~ "Building created successfully"
      assert html =~ "some address"
    end

    test "updates building in listing", %{conn: conn, building: building} do
      {:ok, index_live, _html} = live(conn, Routes.building_index_path(conn, :index))

      assert index_live |> element("#building-#{building.id} a", "Edit") |> render_click() =~
               "Edit Building"

      assert_patch(index_live, Routes.building_index_path(conn, :edit, building))

      assert index_live
             |> form("#building-form", building: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#building-form", building: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.building_index_path(conn, :index))

      assert html =~ "Building updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes building in listing", %{conn: conn, building: building} do
      {:ok, index_live, _html} = live(conn, Routes.building_index_path(conn, :index))

      assert index_live |> element("#building-#{building.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#building-#{building.id}")
    end
  end

  describe "Show" do
    setup [:create_building]

    test "displays building", %{conn: conn, building: building} do
      {:ok, _show_live, html} = live(conn, Routes.building_show_path(conn, :show, building))

      assert html =~ "Show Building"
      assert html =~ building.address
    end

    test "updates building within modal", %{conn: conn, building: building} do
      {:ok, show_live, _html} = live(conn, Routes.building_show_path(conn, :show, building))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Building"

      assert_patch(show_live, Routes.building_show_path(conn, :edit, building))

      assert show_live
             |> form("#building-form", building: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#building-form", building: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.building_show_path(conn, :show, building))

      assert html =~ "Building updated successfully"
      assert html =~ "some updated address"
    end
  end
end

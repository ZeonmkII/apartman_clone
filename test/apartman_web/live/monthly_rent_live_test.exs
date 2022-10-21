defmodule ApartmanWeb.MonthlyRentLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Tenant

  @create_attrs %{bContract: true, bCurrent: true, bTenant: true}
  @update_attrs %{bContract: false, bCurrent: false, bTenant: false}
  @invalid_attrs %{bContract: nil, bCurrent: nil, bTenant: nil}

  defp fixture(:monthly_rent) do
    {:ok, monthly_rent} = Tenant.create_monthly_rent(@create_attrs)
    monthly_rent
  end

  defp create_monthly_rent(_) do
    monthly_rent = fixture(:monthly_rent)
    %{monthly_rent: monthly_rent}
  end

  describe "Index" do
    setup [:create_monthly_rent]

    test "lists all monthlyrents", %{conn: conn, monthly_rent: monthly_rent} do
      {:ok, _index_live, html} = live(conn, Routes.monthly_rent_index_path(conn, :index))

      assert html =~ "Listing Monthlyrents"
    end

    test "saves new monthly_rent", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_rent_index_path(conn, :index))

      assert index_live |> element("a", "New Monthly rent") |> render_click() =~
               "New Monthly rent"

      assert_patch(index_live, Routes.monthly_rent_index_path(conn, :new))

      assert index_live
             |> form("#monthly_rent-form", monthly_rent: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#monthly_rent-form", monthly_rent: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_rent_index_path(conn, :index))

      assert html =~ "Monthly rent created successfully"
    end

    test "updates monthly_rent in listing", %{conn: conn, monthly_rent: monthly_rent} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_rent_index_path(conn, :index))

      assert index_live |> element("#monthly_rent-#{monthly_rent.id} a", "Edit") |> render_click() =~
               "Edit Monthly rent"

      assert_patch(index_live, Routes.monthly_rent_index_path(conn, :edit, monthly_rent))

      assert index_live
             |> form("#monthly_rent-form", monthly_rent: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#monthly_rent-form", monthly_rent: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_rent_index_path(conn, :index))

      assert html =~ "Monthly rent updated successfully"
    end

    test "deletes monthly_rent in listing", %{conn: conn, monthly_rent: monthly_rent} do
      {:ok, index_live, _html} = live(conn, Routes.monthly_rent_index_path(conn, :index))

      assert index_live |> element("#monthly_rent-#{monthly_rent.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#monthly_rent-#{monthly_rent.id}")
    end
  end

  describe "Show" do
    setup [:create_monthly_rent]

    test "displays monthly_rent", %{conn: conn, monthly_rent: monthly_rent} do
      {:ok, _show_live, html} = live(conn, Routes.monthly_rent_show_path(conn, :show, monthly_rent))

      assert html =~ "Show Monthly rent"
    end

    test "updates monthly_rent within modal", %{conn: conn, monthly_rent: monthly_rent} do
      {:ok, show_live, _html} = live(conn, Routes.monthly_rent_show_path(conn, :show, monthly_rent))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Monthly rent"

      assert_patch(show_live, Routes.monthly_rent_show_path(conn, :edit, monthly_rent))

      assert show_live
             |> form("#monthly_rent-form", monthly_rent: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#monthly_rent-form", monthly_rent: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.monthly_rent_show_path(conn, :show, monthly_rent))

      assert html =~ "Monthly rent updated successfully"
    end
  end
end

defmodule ApartmanWeb.DailyRentLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Tenant

  @create_attrs %{bCurrent: true}
  @update_attrs %{bCurrent: false}
  @invalid_attrs %{bCurrent: nil}

  defp fixture(:daily_rent) do
    {:ok, daily_rent} = Tenant.create_daily_rent(@create_attrs)
    daily_rent
  end

  defp create_daily_rent(_) do
    daily_rent = fixture(:daily_rent)
    %{daily_rent: daily_rent}
  end

  describe "Index" do
    setup [:create_daily_rent]

    test "lists all dailyrents", %{conn: conn, daily_rent: daily_rent} do
      {:ok, _index_live, html} = live(conn, Routes.daily_rent_index_path(conn, :index))

      assert html =~ "Listing Dailyrents"
    end

    test "saves new daily_rent", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.daily_rent_index_path(conn, :index))

      assert index_live |> element("a", "New Daily rent") |> render_click() =~
               "New Daily rent"

      assert_patch(index_live, Routes.daily_rent_index_path(conn, :new))

      assert index_live
             |> form("#daily_rent-form", daily_rent: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#daily_rent-form", daily_rent: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_rent_index_path(conn, :index))

      assert html =~ "Daily rent created successfully"
    end

    test "updates daily_rent in listing", %{conn: conn, daily_rent: daily_rent} do
      {:ok, index_live, _html} = live(conn, Routes.daily_rent_index_path(conn, :index))

      assert index_live |> element("#daily_rent-#{daily_rent.id} a", "Edit") |> render_click() =~
               "Edit Daily rent"

      assert_patch(index_live, Routes.daily_rent_index_path(conn, :edit, daily_rent))

      assert index_live
             |> form("#daily_rent-form", daily_rent: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#daily_rent-form", daily_rent: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_rent_index_path(conn, :index))

      assert html =~ "Daily rent updated successfully"
    end

    test "deletes daily_rent in listing", %{conn: conn, daily_rent: daily_rent} do
      {:ok, index_live, _html} = live(conn, Routes.daily_rent_index_path(conn, :index))

      assert index_live |> element("#daily_rent-#{daily_rent.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#daily_rent-#{daily_rent.id}")
    end
  end

  describe "Show" do
    setup [:create_daily_rent]

    test "displays daily_rent", %{conn: conn, daily_rent: daily_rent} do
      {:ok, _show_live, html} = live(conn, Routes.daily_rent_show_path(conn, :show, daily_rent))

      assert html =~ "Show Daily rent"
    end

    test "updates daily_rent within modal", %{conn: conn, daily_rent: daily_rent} do
      {:ok, show_live, _html} = live(conn, Routes.daily_rent_show_path(conn, :show, daily_rent))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Daily rent"

      assert_patch(show_live, Routes.daily_rent_show_path(conn, :edit, daily_rent))

      assert show_live
             |> form("#daily_rent-form", daily_rent: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#daily_rent-form", daily_rent: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.daily_rent_show_path(conn, :show, daily_rent))

      assert html =~ "Daily rent updated successfully"
    end
  end
end

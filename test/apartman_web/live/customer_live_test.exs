defmodule ApartmanWeb.CustomerLiveTest do
  use ApartmanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apartman.Tenant

  @create_attrs %{address: "some address", datOfBirth: ~D[2010-04-17], dateOfExpiry: ~D[2010-04-17], dateOfIssue: ~D[2010-04-17], emergencyContact: "some emergencyContact", faith: "some faith", firstName: "some firstName", firstNameAlt: "some firstNameAlt", idNumber: "some idNumber", issueBy: "some issueBy", lastName: "some lastName", lastNameAlt: "some lastNameAlt", line: "some line", nationality: "some nationality", occupation: "some occupation", phone: "some phone", photo: "some photo", sex: "some sex"}
  @update_attrs %{address: "some updated address", datOfBirth: ~D[2011-05-18], dateOfExpiry: ~D[2011-05-18], dateOfIssue: ~D[2011-05-18], emergencyContact: "some updated emergencyContact", faith: "some updated faith", firstName: "some updated firstName", firstNameAlt: "some updated firstNameAlt", idNumber: "some updated idNumber", issueBy: "some updated issueBy", lastName: "some updated lastName", lastNameAlt: "some updated lastNameAlt", line: "some updated line", nationality: "some updated nationality", occupation: "some updated occupation", phone: "some updated phone", photo: "some updated photo", sex: "some updated sex"}
  @invalid_attrs %{address: nil, datOfBirth: nil, dateOfExpiry: nil, dateOfIssue: nil, emergencyContact: nil, faith: nil, firstName: nil, firstNameAlt: nil, idNumber: nil, issueBy: nil, lastName: nil, lastNameAlt: nil, line: nil, nationality: nil, occupation: nil, phone: nil, photo: nil, sex: nil}

  defp fixture(:customer) do
    {:ok, customer} = Tenant.create_customer(@create_attrs)
    customer
  end

  defp create_customer(_) do
    customer = fixture(:customer)
    %{customer: customer}
  end

  describe "Index" do
    setup [:create_customer]

    test "lists all customers", %{conn: conn, customer: customer} do
      {:ok, _index_live, html} = live(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Listing Customers"
      assert html =~ customer.address
    end

    test "saves new customer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("a", "New Customer") |> render_click() =~
               "New Customer"

      assert_patch(index_live, Routes.customer_index_path(conn, :new))

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#customer-form", customer: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Customer created successfully"
      assert html =~ "some address"
    end

    test "updates customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("#customer-#{customer.id} a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(index_live, Routes.customer_index_path(conn, :edit, customer))

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#customer-form", customer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Customer updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("#customer-#{customer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#customer-#{customer.id}")
    end
  end

  describe "Show" do
    setup [:create_customer]

    test "displays customer", %{conn: conn, customer: customer} do
      {:ok, _show_live, html} = live(conn, Routes.customer_show_path(conn, :show, customer))

      assert html =~ "Show Customer"
      assert html =~ customer.address
    end

    test "updates customer within modal", %{conn: conn, customer: customer} do
      {:ok, show_live, _html} = live(conn, Routes.customer_show_path(conn, :show, customer))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(show_live, Routes.customer_show_path(conn, :edit, customer))

      assert show_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#customer-form", customer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_show_path(conn, :show, customer))

      assert html =~ "Customer updated successfully"
      assert html =~ "some updated address"
    end
  end
end

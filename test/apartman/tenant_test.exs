defmodule Apartman.TenantTest do
  use Apartman.DataCase

  alias Apartman.Tenant

  describe "customers" do
    alias Apartman.Tenant.Customer

    @valid_attrs %{address: "some address", datOfBirth: ~D[2010-04-17], dateOfExpiry: ~D[2010-04-17], dateOfIssue: ~D[2010-04-17], emergencyContact: "some emergencyContact", faith: "some faith", firstName: "some firstName", firstNameAlt: "some firstNameAlt", idNumber: "some idNumber", issueBy: "some issueBy", lastName: "some lastName", lastNameAlt: "some lastNameAlt", line: "some line", nationality: "some nationality", occupation: "some occupation", phone: "some phone", photo: "some photo", sex: "some sex"}
    @update_attrs %{address: "some updated address", datOfBirth: ~D[2011-05-18], dateOfExpiry: ~D[2011-05-18], dateOfIssue: ~D[2011-05-18], emergencyContact: "some updated emergencyContact", faith: "some updated faith", firstName: "some updated firstName", firstNameAlt: "some updated firstNameAlt", idNumber: "some updated idNumber", issueBy: "some updated issueBy", lastName: "some updated lastName", lastNameAlt: "some updated lastNameAlt", line: "some updated line", nationality: "some updated nationality", occupation: "some updated occupation", phone: "some updated phone", photo: "some updated photo", sex: "some updated sex"}
    @invalid_attrs %{address: nil, datOfBirth: nil, dateOfExpiry: nil, dateOfIssue: nil, emergencyContact: nil, faith: nil, firstName: nil, firstNameAlt: nil, idNumber: nil, issueBy: nil, lastName: nil, lastNameAlt: nil, line: nil, nationality: nil, occupation: nil, phone: nil, photo: nil, sex: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tenant.create_customer()

      customer
    end

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Tenant.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Tenant.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Tenant.create_customer(@valid_attrs)
      assert customer.address == "some address"
      assert customer.datOfBirth == ~D[2010-04-17]
      assert customer.dateOfExpiry == ~D[2010-04-17]
      assert customer.dateOfIssue == ~D[2010-04-17]
      assert customer.emergencyContact == "some emergencyContact"
      assert customer.faith == "some faith"
      assert customer.firstName == "some firstName"
      assert customer.firstNameAlt == "some firstNameAlt"
      assert customer.idNumber == "some idNumber"
      assert customer.issueBy == "some issueBy"
      assert customer.lastName == "some lastName"
      assert customer.lastNameAlt == "some lastNameAlt"
      assert customer.line == "some line"
      assert customer.nationality == "some nationality"
      assert customer.occupation == "some occupation"
      assert customer.phone == "some phone"
      assert customer.photo == "some photo"
      assert customer.sex == "some sex"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenant.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Tenant.update_customer(customer, @update_attrs)
      assert customer.address == "some updated address"
      assert customer.datOfBirth == ~D[2011-05-18]
      assert customer.dateOfExpiry == ~D[2011-05-18]
      assert customer.dateOfIssue == ~D[2011-05-18]
      assert customer.emergencyContact == "some updated emergencyContact"
      assert customer.faith == "some updated faith"
      assert customer.firstName == "some updated firstName"
      assert customer.firstNameAlt == "some updated firstNameAlt"
      assert customer.idNumber == "some updated idNumber"
      assert customer.issueBy == "some updated issueBy"
      assert customer.lastName == "some updated lastName"
      assert customer.lastNameAlt == "some updated lastNameAlt"
      assert customer.line == "some updated line"
      assert customer.nationality == "some updated nationality"
      assert customer.occupation == "some updated occupation"
      assert customer.phone == "some updated phone"
      assert customer.photo == "some updated photo"
      assert customer.sex == "some updated sex"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenant.update_customer(customer, @invalid_attrs)
      assert customer == Tenant.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Tenant.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Tenant.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Tenant.change_customer(customer)
    end
  end

  describe "dailyrents" do
    alias Apartman.Tenant.DailyRent

    @valid_attrs %{bCurrent: true}
    @update_attrs %{bCurrent: false}
    @invalid_attrs %{bCurrent: nil}

    def daily_rent_fixture(attrs \\ %{}) do
      {:ok, daily_rent} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tenant.create_daily_rent()

      daily_rent
    end

    test "list_dailyrents/0 returns all dailyrents" do
      daily_rent = daily_rent_fixture()
      assert Tenant.list_dailyrents() == [daily_rent]
    end

    test "get_daily_rent!/1 returns the daily_rent with given id" do
      daily_rent = daily_rent_fixture()
      assert Tenant.get_daily_rent!(daily_rent.id) == daily_rent
    end

    test "create_daily_rent/1 with valid data creates a daily_rent" do
      assert {:ok, %DailyRent{} = daily_rent} = Tenant.create_daily_rent(@valid_attrs)
      assert daily_rent.bCurrent == true
    end

    test "create_daily_rent/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenant.create_daily_rent(@invalid_attrs)
    end

    test "update_daily_rent/2 with valid data updates the daily_rent" do
      daily_rent = daily_rent_fixture()
      assert {:ok, %DailyRent{} = daily_rent} = Tenant.update_daily_rent(daily_rent, @update_attrs)
      assert daily_rent.bCurrent == false
    end

    test "update_daily_rent/2 with invalid data returns error changeset" do
      daily_rent = daily_rent_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenant.update_daily_rent(daily_rent, @invalid_attrs)
      assert daily_rent == Tenant.get_daily_rent!(daily_rent.id)
    end

    test "delete_daily_rent/1 deletes the daily_rent" do
      daily_rent = daily_rent_fixture()
      assert {:ok, %DailyRent{}} = Tenant.delete_daily_rent(daily_rent)
      assert_raise Ecto.NoResultsError, fn -> Tenant.get_daily_rent!(daily_rent.id) end
    end

    test "change_daily_rent/1 returns a daily_rent changeset" do
      daily_rent = daily_rent_fixture()
      assert %Ecto.Changeset{} = Tenant.change_daily_rent(daily_rent)
    end
  end

  describe "monthlyrents" do
    alias Apartman.Tenant.MonthlyRent

    @valid_attrs %{bContract: true, bCurrent: true, bTenant: true}
    @update_attrs %{bContract: false, bCurrent: false, bTenant: false}
    @invalid_attrs %{bContract: nil, bCurrent: nil, bTenant: nil}

    def monthly_rent_fixture(attrs \\ %{}) do
      {:ok, monthly_rent} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tenant.create_monthly_rent()

      monthly_rent
    end

    test "list_monthlyrents/0 returns all monthlyrents" do
      monthly_rent = monthly_rent_fixture()
      assert Tenant.list_monthlyrents() == [monthly_rent]
    end

    test "get_monthly_rent!/1 returns the monthly_rent with given id" do
      monthly_rent = monthly_rent_fixture()
      assert Tenant.get_monthly_rent!(monthly_rent.id) == monthly_rent
    end

    test "create_monthly_rent/1 with valid data creates a monthly_rent" do
      assert {:ok, %MonthlyRent{} = monthly_rent} = Tenant.create_monthly_rent(@valid_attrs)
      assert monthly_rent.bContract == true
      assert monthly_rent.bCurrent == true
      assert monthly_rent.bTenant == true
    end

    test "create_monthly_rent/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenant.create_monthly_rent(@invalid_attrs)
    end

    test "update_monthly_rent/2 with valid data updates the monthly_rent" do
      monthly_rent = monthly_rent_fixture()
      assert {:ok, %MonthlyRent{} = monthly_rent} = Tenant.update_monthly_rent(monthly_rent, @update_attrs)
      assert monthly_rent.bContract == false
      assert monthly_rent.bCurrent == false
      assert monthly_rent.bTenant == false
    end

    test "update_monthly_rent/2 with invalid data returns error changeset" do
      monthly_rent = monthly_rent_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenant.update_monthly_rent(monthly_rent, @invalid_attrs)
      assert monthly_rent == Tenant.get_monthly_rent!(monthly_rent.id)
    end

    test "delete_monthly_rent/1 deletes the monthly_rent" do
      monthly_rent = monthly_rent_fixture()
      assert {:ok, %MonthlyRent{}} = Tenant.delete_monthly_rent(monthly_rent)
      assert_raise Ecto.NoResultsError, fn -> Tenant.get_monthly_rent!(monthly_rent.id) end
    end

    test "change_monthly_rent/1 returns a monthly_rent changeset" do
      monthly_rent = monthly_rent_fixture()
      assert %Ecto.Changeset{} = Tenant.change_monthly_rent(monthly_rent)
    end
  end
end

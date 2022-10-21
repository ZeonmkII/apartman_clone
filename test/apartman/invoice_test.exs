defmodule Apartman.InvoiceTest do
  use Apartman.DataCase

  alias Apartman.Invoice

  describe "bookingfees" do
    alias Apartman.Invoice.BookingFee

    @valid_attrs %{bookingFees: "some bookingFees"}
    @update_attrs %{bookingFees: "some updated bookingFees"}
    @invalid_attrs %{bookingFees: nil}

    def booking_fee_fixture(attrs \\ %{}) do
      {:ok, booking_fee} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Invoice.create_booking_fee()

      booking_fee
    end

    test "list_bookingfees/0 returns all bookingfees" do
      booking_fee = booking_fee_fixture()
      assert Invoice.list_bookingfees() == [booking_fee]
    end

    test "get_booking_fee!/1 returns the booking_fee with given id" do
      booking_fee = booking_fee_fixture()
      assert Invoice.get_booking_fee!(booking_fee.id) == booking_fee
    end

    test "create_booking_fee/1 with valid data creates a booking_fee" do
      assert {:ok, %BookingFee{} = booking_fee} = Invoice.create_booking_fee(@valid_attrs)
      assert booking_fee.bookingFees == "some bookingFees"
    end

    test "create_booking_fee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoice.create_booking_fee(@invalid_attrs)
    end

    test "update_booking_fee/2 with valid data updates the booking_fee" do
      booking_fee = booking_fee_fixture()
      assert {:ok, %BookingFee{} = booking_fee} = Invoice.update_booking_fee(booking_fee, @update_attrs)
      assert booking_fee.bookingFees == "some updated bookingFees"
    end

    test "update_booking_fee/2 with invalid data returns error changeset" do
      booking_fee = booking_fee_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoice.update_booking_fee(booking_fee, @invalid_attrs)
      assert booking_fee == Invoice.get_booking_fee!(booking_fee.id)
    end

    test "delete_booking_fee/1 deletes the booking_fee" do
      booking_fee = booking_fee_fixture()
      assert {:ok, %BookingFee{}} = Invoice.delete_booking_fee(booking_fee)
      assert_raise Ecto.NoResultsError, fn -> Invoice.get_booking_fee!(booking_fee.id) end
    end

    test "change_booking_fee/1 returns a booking_fee changeset" do
      booking_fee = booking_fee_fixture()
      assert %Ecto.Changeset{} = Invoice.change_booking_fee(booking_fee)
    end
  end

  describe "dailyinvoices" do
    alias Apartman.Invoice.DailyInvoice

    @valid_attrs %{advancePayment: "some advancePayment", deposit: "some deposit", keycardFees: "some keycardFees", otherFees: "some otherFees", otherLabels: "some otherLabels"}
    @update_attrs %{advancePayment: "some updated advancePayment", deposit: "some updated deposit", keycardFees: "some updated keycardFees", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels"}
    @invalid_attrs %{advancePayment: nil, deposit: nil, keycardFees: nil, otherFees: nil, otherLabels: nil}

    def daily_invoice_fixture(attrs \\ %{}) do
      {:ok, daily_invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Invoice.create_daily_invoice()

      daily_invoice
    end

    test "list_dailyinvoices/0 returns all dailyinvoices" do
      daily_invoice = daily_invoice_fixture()
      assert Invoice.list_dailyinvoices() == [daily_invoice]
    end

    test "get_daily_invoice!/1 returns the daily_invoice with given id" do
      daily_invoice = daily_invoice_fixture()
      assert Invoice.get_daily_invoice!(daily_invoice.id) == daily_invoice
    end

    test "create_daily_invoice/1 with valid data creates a daily_invoice" do
      assert {:ok, %DailyInvoice{} = daily_invoice} = Invoice.create_daily_invoice(@valid_attrs)
      assert daily_invoice.advancePayment == "some advancePayment"
      assert daily_invoice.deposit == "some deposit"
      assert daily_invoice.keycardFees == "some keycardFees"
      assert daily_invoice.otherFees == "some otherFees"
      assert daily_invoice.otherLabels == "some otherLabels"
    end

    test "create_daily_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoice.create_daily_invoice(@invalid_attrs)
    end

    test "update_daily_invoice/2 with valid data updates the daily_invoice" do
      daily_invoice = daily_invoice_fixture()
      assert {:ok, %DailyInvoice{} = daily_invoice} = Invoice.update_daily_invoice(daily_invoice, @update_attrs)
      assert daily_invoice.advancePayment == "some updated advancePayment"
      assert daily_invoice.deposit == "some updated deposit"
      assert daily_invoice.keycardFees == "some updated keycardFees"
      assert daily_invoice.otherFees == "some updated otherFees"
      assert daily_invoice.otherLabels == "some updated otherLabels"
    end

    test "update_daily_invoice/2 with invalid data returns error changeset" do
      daily_invoice = daily_invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoice.update_daily_invoice(daily_invoice, @invalid_attrs)
      assert daily_invoice == Invoice.get_daily_invoice!(daily_invoice.id)
    end

    test "delete_daily_invoice/1 deletes the daily_invoice" do
      daily_invoice = daily_invoice_fixture()
      assert {:ok, %DailyInvoice{}} = Invoice.delete_daily_invoice(daily_invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoice.get_daily_invoice!(daily_invoice.id) end
    end

    test "change_daily_invoice/1 returns a daily_invoice changeset" do
      daily_invoice = daily_invoice_fixture()
      assert %Ecto.Changeset{} = Invoice.change_daily_invoice(daily_invoice)
    end
  end

  describe "monthlyinvoices" do
    alias Apartman.Invoice.MonthlyInvoice

    @valid_attrs %{advancePayment: "some advancePayment", billCycle: ~D[2010-04-17], electricStart: "some electricStart", eletricEnd: "some eletricEnd", otherFees: "some otherFees", otherLabels: "some otherLabels", waterEnd: "some waterEnd", waterStart: "some waterStart", waterUnit: "some waterUnit"}
    @update_attrs %{advancePayment: "some updated advancePayment", billCycle: ~D[2011-05-18], electricStart: "some updated electricStart", eletricEnd: "some updated eletricEnd", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels", waterEnd: "some updated waterEnd", waterStart: "some updated waterStart", waterUnit: "some updated waterUnit"}
    @invalid_attrs %{advancePayment: nil, billCycle: nil, electricStart: nil, eletricEnd: nil, otherFees: nil, otherLabels: nil, waterEnd: nil, waterStart: nil, waterUnit: nil}

    def monthly_invoice_fixture(attrs \\ %{}) do
      {:ok, monthly_invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Invoice.create_monthly_invoice()

      monthly_invoice
    end

    test "list_monthlyinvoices/0 returns all monthlyinvoices" do
      monthly_invoice = monthly_invoice_fixture()
      assert Invoice.list_monthlyinvoices() == [monthly_invoice]
    end

    test "get_monthly_invoice!/1 returns the monthly_invoice with given id" do
      monthly_invoice = monthly_invoice_fixture()
      assert Invoice.get_monthly_invoice!(monthly_invoice.id) == monthly_invoice
    end

    test "create_monthly_invoice/1 with valid data creates a monthly_invoice" do
      assert {:ok, %MonthlyInvoice{} = monthly_invoice} = Invoice.create_monthly_invoice(@valid_attrs)
      assert monthly_invoice.advancePayment == "some advancePayment"
      assert monthly_invoice.billCycle == ~D[2010-04-17]
      assert monthly_invoice.electricStart == "some electricStart"
      assert monthly_invoice.eletricEnd == "some eletricEnd"
      assert monthly_invoice.otherFees == "some otherFees"
      assert monthly_invoice.otherLabels == "some otherLabels"
      assert monthly_invoice.waterEnd == "some waterEnd"
      assert monthly_invoice.waterStart == "some waterStart"
      assert monthly_invoice.waterUnit == "some waterUnit"
    end

    test "create_monthly_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoice.create_monthly_invoice(@invalid_attrs)
    end

    test "update_monthly_invoice/2 with valid data updates the monthly_invoice" do
      monthly_invoice = monthly_invoice_fixture()
      assert {:ok, %MonthlyInvoice{} = monthly_invoice} = Invoice.update_monthly_invoice(monthly_invoice, @update_attrs)
      assert monthly_invoice.advancePayment == "some updated advancePayment"
      assert monthly_invoice.billCycle == ~D[2011-05-18]
      assert monthly_invoice.electricStart == "some updated electricStart"
      assert monthly_invoice.eletricEnd == "some updated eletricEnd"
      assert monthly_invoice.otherFees == "some updated otherFees"
      assert monthly_invoice.otherLabels == "some updated otherLabels"
      assert monthly_invoice.waterEnd == "some updated waterEnd"
      assert monthly_invoice.waterStart == "some updated waterStart"
      assert monthly_invoice.waterUnit == "some updated waterUnit"
    end

    test "update_monthly_invoice/2 with invalid data returns error changeset" do
      monthly_invoice = monthly_invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoice.update_monthly_invoice(monthly_invoice, @invalid_attrs)
      assert monthly_invoice == Invoice.get_monthly_invoice!(monthly_invoice.id)
    end

    test "delete_monthly_invoice/1 deletes the monthly_invoice" do
      monthly_invoice = monthly_invoice_fixture()
      assert {:ok, %MonthlyInvoice{}} = Invoice.delete_monthly_invoice(monthly_invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoice.get_monthly_invoice!(monthly_invoice.id) end
    end

    test "change_monthly_invoice/1 returns a monthly_invoice changeset" do
      monthly_invoice = monthly_invoice_fixture()
      assert %Ecto.Changeset{} = Invoice.change_monthly_invoice(monthly_invoice)
    end
  end
end

defmodule Apartman.BookingTest do
  use Apartman.DataCase

  alias Apartman.Booking

  describe "dailybookings" do
    alias Apartman.Booking.DailyBooking

    @valid_attrs %{bookingId: "some bookingId", checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], durationDay: 42, remarks: "some remarks"}
    @update_attrs %{bookingId: "some updated bookingId", checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], durationDay: 43, remarks: "some updated remarks"}
    @invalid_attrs %{bookingId: nil, checkIn: nil, checkOut: nil, durationDay: nil, remarks: nil}

    def daily_booking_fixture(attrs \\ %{}) do
      {:ok, daily_booking} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Booking.create_daily_booking()

      daily_booking
    end

    test "list_dailybookings/0 returns all dailybookings" do
      daily_booking = daily_booking_fixture()
      assert Booking.list_dailybookings() == [daily_booking]
    end

    test "get_daily_booking!/1 returns the daily_booking with given id" do
      daily_booking = daily_booking_fixture()
      assert Booking.get_daily_booking!(daily_booking.id) == daily_booking
    end

    test "create_daily_booking/1 with valid data creates a daily_booking" do
      assert {:ok, %DailyBooking{} = daily_booking} = Booking.create_daily_booking(@valid_attrs)
      assert daily_booking.bookingId == "some bookingId"
      assert daily_booking.checkIn == ~D[2010-04-17]
      assert daily_booking.checkOut == ~D[2010-04-17]
      assert daily_booking.durationDay == 42
      assert daily_booking.remarks == "some remarks"
    end

    test "create_daily_booking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Booking.create_daily_booking(@invalid_attrs)
    end

    test "update_daily_booking/2 with valid data updates the daily_booking" do
      daily_booking = daily_booking_fixture()
      assert {:ok, %DailyBooking{} = daily_booking} = Booking.update_daily_booking(daily_booking, @update_attrs)
      assert daily_booking.bookingId == "some updated bookingId"
      assert daily_booking.checkIn == ~D[2011-05-18]
      assert daily_booking.checkOut == ~D[2011-05-18]
      assert daily_booking.durationDay == 43
      assert daily_booking.remarks == "some updated remarks"
    end

    test "update_daily_booking/2 with invalid data returns error changeset" do
      daily_booking = daily_booking_fixture()
      assert {:error, %Ecto.Changeset{}} = Booking.update_daily_booking(daily_booking, @invalid_attrs)
      assert daily_booking == Booking.get_daily_booking!(daily_booking.id)
    end

    test "delete_daily_booking/1 deletes the daily_booking" do
      daily_booking = daily_booking_fixture()
      assert {:ok, %DailyBooking{}} = Booking.delete_daily_booking(daily_booking)
      assert_raise Ecto.NoResultsError, fn -> Booking.get_daily_booking!(daily_booking.id) end
    end

    test "change_daily_booking/1 returns a daily_booking changeset" do
      daily_booking = daily_booking_fixture()
      assert %Ecto.Changeset{} = Booking.change_daily_booking(daily_booking)
    end
  end

  describe "monthlybookings" do
    alias Apartman.Booking.MonthlyBooking

    @valid_attrs %{advancePayment: "some advancePayment", bookingId: "some bookingId", checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], deposit: "some deposit", durationDay: 42, durationMonth: 42, keycardFees: "some keycardFees", otherFees: "some otherFees", otherLabels: "some otherLabels", remarks: "some remarks", rentFees: "some rentFees", serviceFees: "some serviceFees"}
    @update_attrs %{advancePayment: "some updated advancePayment", bookingId: "some updated bookingId", checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], deposit: "some updated deposit", durationDay: 43, durationMonth: 43, keycardFees: "some updated keycardFees", otherFees: "some updated otherFees", otherLabels: "some updated otherLabels", remarks: "some updated remarks", rentFees: "some updated rentFees", serviceFees: "some updated serviceFees"}
    @invalid_attrs %{advancePayment: nil, bookingId: nil, checkIn: nil, checkOut: nil, deposit: nil, durationDay: nil, durationMonth: nil, keycardFees: nil, otherFees: nil, otherLabels: nil, remarks: nil, rentFees: nil, serviceFees: nil}

    def monthly_booking_fixture(attrs \\ %{}) do
      {:ok, monthly_booking} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Booking.create_monthly_booking()

      monthly_booking
    end

    test "list_monthlybookings/0 returns all monthlybookings" do
      monthly_booking = monthly_booking_fixture()
      assert Booking.list_monthlybookings() == [monthly_booking]
    end

    test "get_monthly_booking!/1 returns the monthly_booking with given id" do
      monthly_booking = monthly_booking_fixture()
      assert Booking.get_monthly_booking!(monthly_booking.id) == monthly_booking
    end

    test "create_monthly_booking/1 with valid data creates a monthly_booking" do
      assert {:ok, %MonthlyBooking{} = monthly_booking} = Booking.create_monthly_booking(@valid_attrs)
      assert monthly_booking.advancePayment == "some advancePayment"
      assert monthly_booking.bookingId == "some bookingId"
      assert monthly_booking.checkIn == ~D[2010-04-17]
      assert monthly_booking.checkOut == ~D[2010-04-17]
      assert monthly_booking.deposit == "some deposit"
      assert monthly_booking.durationDay == 42
      assert monthly_booking.durationMonth == 42
      assert monthly_booking.keycardFees == "some keycardFees"
      assert monthly_booking.otherFees == "some otherFees"
      assert monthly_booking.otherLabels == "some otherLabels"
      assert monthly_booking.remarks == "some remarks"
      assert monthly_booking.rentFees == "some rentFees"
      assert monthly_booking.serviceFees == "some serviceFees"
    end

    test "create_monthly_booking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Booking.create_monthly_booking(@invalid_attrs)
    end

    test "update_monthly_booking/2 with valid data updates the monthly_booking" do
      monthly_booking = monthly_booking_fixture()
      assert {:ok, %MonthlyBooking{} = monthly_booking} = Booking.update_monthly_booking(monthly_booking, @update_attrs)
      assert monthly_booking.advancePayment == "some updated advancePayment"
      assert monthly_booking.bookingId == "some updated bookingId"
      assert monthly_booking.checkIn == ~D[2011-05-18]
      assert monthly_booking.checkOut == ~D[2011-05-18]
      assert monthly_booking.deposit == "some updated deposit"
      assert monthly_booking.durationDay == 43
      assert monthly_booking.durationMonth == 43
      assert monthly_booking.keycardFees == "some updated keycardFees"
      assert monthly_booking.otherFees == "some updated otherFees"
      assert monthly_booking.otherLabels == "some updated otherLabels"
      assert monthly_booking.remarks == "some updated remarks"
      assert monthly_booking.rentFees == "some updated rentFees"
      assert monthly_booking.serviceFees == "some updated serviceFees"
    end

    test "update_monthly_booking/2 with invalid data returns error changeset" do
      monthly_booking = monthly_booking_fixture()
      assert {:error, %Ecto.Changeset{}} = Booking.update_monthly_booking(monthly_booking, @invalid_attrs)
      assert monthly_booking == Booking.get_monthly_booking!(monthly_booking.id)
    end

    test "delete_monthly_booking/1 deletes the monthly_booking" do
      monthly_booking = monthly_booking_fixture()
      assert {:ok, %MonthlyBooking{}} = Booking.delete_monthly_booking(monthly_booking)
      assert_raise Ecto.NoResultsError, fn -> Booking.get_monthly_booking!(monthly_booking.id) end
    end

    test "change_monthly_booking/1 returns a monthly_booking changeset" do
      monthly_booking = monthly_booking_fixture()
      assert %Ecto.Changeset{} = Booking.change_monthly_booking(monthly_booking)
    end
  end

  describe "checkins" do
    alias Apartman.Booking.Checkin

    @valid_attrs %{checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], deposit: "some deposit", durationDay: 42, from: "some from", remarks: "some remarks", roomNumber: "some roomNumber", timeIn: ~T[14:00:00], timeOut: ~T[14:00:00], to: "some to"}
    @update_attrs %{checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], deposit: "some updated deposit", durationDay: 43, from: "some updated from", remarks: "some updated remarks", roomNumber: "some updated roomNumber", timeIn: ~T[15:01:01], timeOut: ~T[15:01:01], to: "some updated to"}
    @invalid_attrs %{checkIn: nil, checkOut: nil, deposit: nil, durationDay: nil, from: nil, remarks: nil, roomNumber: nil, timeIn: nil, timeOut: nil, to: nil}

    def checkin_fixture(attrs \\ %{}) do
      {:ok, checkin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Booking.create_checkin()

      checkin
    end

    test "list_checkins/0 returns all checkins" do
      checkin = checkin_fixture()
      assert Booking.list_checkins() == [checkin]
    end

    test "get_checkin!/1 returns the checkin with given id" do
      checkin = checkin_fixture()
      assert Booking.get_checkin!(checkin.id) == checkin
    end

    test "create_checkin/1 with valid data creates a checkin" do
      assert {:ok, %Checkin{} = checkin} = Booking.create_checkin(@valid_attrs)
      assert checkin.checkIn == ~D[2010-04-17]
      assert checkin.checkOut == ~D[2010-04-17]
      assert checkin.deposit == "some deposit"
      assert checkin.durationDay == 42
      assert checkin.from == "some from"
      assert checkin.remarks == "some remarks"
      assert checkin.roomNumber == "some roomNumber"
      assert checkin.timeIn == ~T[14:00:00]
      assert checkin.timeOut == ~T[14:00:00]
      assert checkin.to == "some to"
    end

    test "create_checkin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Booking.create_checkin(@invalid_attrs)
    end

    test "update_checkin/2 with valid data updates the checkin" do
      checkin = checkin_fixture()
      assert {:ok, %Checkin{} = checkin} = Booking.update_checkin(checkin, @update_attrs)
      assert checkin.checkIn == ~D[2011-05-18]
      assert checkin.checkOut == ~D[2011-05-18]
      assert checkin.deposit == "some updated deposit"
      assert checkin.durationDay == 43
      assert checkin.from == "some updated from"
      assert checkin.remarks == "some updated remarks"
      assert checkin.roomNumber == "some updated roomNumber"
      assert checkin.timeIn == ~T[15:01:01]
      assert checkin.timeOut == ~T[15:01:01]
      assert checkin.to == "some updated to"
    end

    test "update_checkin/2 with invalid data returns error changeset" do
      checkin = checkin_fixture()
      assert {:error, %Ecto.Changeset{}} = Booking.update_checkin(checkin, @invalid_attrs)
      assert checkin == Booking.get_checkin!(checkin.id)
    end

    test "delete_checkin/1 deletes the checkin" do
      checkin = checkin_fixture()
      assert {:ok, %Checkin{}} = Booking.delete_checkin(checkin)
      assert_raise Ecto.NoResultsError, fn -> Booking.get_checkin!(checkin.id) end
    end

    test "change_checkin/1 returns a checkin changeset" do
      checkin = checkin_fixture()
      assert %Ecto.Changeset{} = Booking.change_checkin(checkin)
    end
  end

  describe "contracts" do
    alias Apartman.Booking.Contract

    @valid_attrs %{advancePayment: "some advancePayment", checkIn: ~D[2010-04-17], checkOut: ~D[2010-04-17], contractId: "some contractId", dateSigned: ~D[2010-04-17], deposit: "some deposit", durationDay: 42, durationMonth: 42, keycardFees: "some keycardFees", keycardNumber: "some keycardNumber", meterElectric: 120.5, meterWater: 120.5, otherFees: "some otherFees", otherLabels: "some otherLabels", remarks: "some remarks", rentFees: "some rentFees", roomNumber: "some roomNumber", serviceFees: "some serviceFees"}
    @update_attrs %{advancePayment: "some updated advancePayment", checkIn: ~D[2011-05-18], checkOut: ~D[2011-05-18], contractId: "some updated contractId", dateSigned: ~D[2011-05-18], deposit: "some updated deposit", durationDay: 43, durationMonth: 43, keycardFees: "some updated keycardFees", keycardNumber: "some updated keycardNumber", meterElectric: 456.7, meterWater: 456.7, otherFees: "some updated otherFees", otherLabels: "some updated otherLabels", remarks: "some updated remarks", rentFees: "some updated rentFees", roomNumber: "some updated roomNumber", serviceFees: "some updated serviceFees"}
    @invalid_attrs %{advancePayment: nil, checkIn: nil, checkOut: nil, contractId: nil, dateSigned: nil, deposit: nil, durationDay: nil, durationMonth: nil, keycardFees: nil, keycardNumber: nil, meterElectric: nil, meterWater: nil, otherFees: nil, otherLabels: nil, remarks: nil, rentFees: nil, roomNumber: nil, serviceFees: nil}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Booking.create_contract()

      contract
    end

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Booking.list_contracts() == [contract]
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Booking.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      assert {:ok, %Contract{} = contract} = Booking.create_contract(@valid_attrs)
      assert contract.advancePayment == "some advancePayment"
      assert contract.checkIn == ~D[2010-04-17]
      assert contract.checkOut == ~D[2010-04-17]
      assert contract.contractId == "some contractId"
      assert contract.dateSigned == ~D[2010-04-17]
      assert contract.deposit == "some deposit"
      assert contract.durationDay == 42
      assert contract.durationMonth == 42
      assert contract.keycardFees == "some keycardFees"
      assert contract.keycardNumber == "some keycardNumber"
      assert contract.meterElectric == 120.5
      assert contract.meterWater == 120.5
      assert contract.otherFees == "some otherFees"
      assert contract.otherLabels == "some otherLabels"
      assert contract.remarks == "some remarks"
      assert contract.rentFees == "some rentFees"
      assert contract.roomNumber == "some roomNumber"
      assert contract.serviceFees == "some serviceFees"
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Booking.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, %Contract{} = contract} = Booking.update_contract(contract, @update_attrs)
      assert contract.advancePayment == "some updated advancePayment"
      assert contract.checkIn == ~D[2011-05-18]
      assert contract.checkOut == ~D[2011-05-18]
      assert contract.contractId == "some updated contractId"
      assert contract.dateSigned == ~D[2011-05-18]
      assert contract.deposit == "some updated deposit"
      assert contract.durationDay == 43
      assert contract.durationMonth == 43
      assert contract.keycardFees == "some updated keycardFees"
      assert contract.keycardNumber == "some updated keycardNumber"
      assert contract.meterElectric == 456.7
      assert contract.meterWater == 456.7
      assert contract.otherFees == "some updated otherFees"
      assert contract.otherLabels == "some updated otherLabels"
      assert contract.remarks == "some updated remarks"
      assert contract.rentFees == "some updated rentFees"
      assert contract.roomNumber == "some updated roomNumber"
      assert contract.serviceFees == "some updated serviceFees"
    end

    test "update_contract/2 with invalid data returns error changeset" do
      contract = contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Booking.update_contract(contract, @invalid_attrs)
      assert contract == Booking.get_contract!(contract.id)
    end

    test "delete_contract/1 deletes the contract" do
      contract = contract_fixture()
      assert {:ok, %Contract{}} = Booking.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Booking.get_contract!(contract.id) end
    end

    test "change_contract/1 returns a contract changeset" do
      contract = contract_fixture()
      assert %Ecto.Changeset{} = Booking.change_contract(contract)
    end
  end
end

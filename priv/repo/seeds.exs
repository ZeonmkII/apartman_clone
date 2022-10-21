# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Apartman.Repo.insert!(%Apartman.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

#  ******************************************************************************
#  ******************************************************************************
#  ************************ Set-Up Data  ****************************************
#
# Floors & Rooms
total_floors = 7
rooms_per_floor = 13
#
# Fake Bookings
total_customers = 10
total_bookings = 30
#
#  ********************* END: Set-Up Data  **************************************
#  ******************************************************************************
#  ******************************************************************************

#  ******************* Insert test Accounts *************************************

alias Apartman.Account
alias Apartman.Repo

admin1 = %{
  userName: "admin1",
  password: "password1",
  password_confirmation: "password1",
  firstName: "Mathus",
  lastName: "Tuachob",
  email: "ADMINone@jresident.com",
  phone: "0861234567",
  line: "adminone",
  role: "admin"
}

admin2 = %{
  userName: "admin2",
  password: "password2",
  password_confirmation: "password2",
  firstName: "PaRn",
  lastName: "Thanapat",
  email: "adminTWO@HORPAK.com",
  phone: "0869876543",
  line: "admintwo",
  role: "admin"
}

user1 = %{
  userName: "user1",
  password: "password",
  password_confirmation: "password",
  firstName: "FAKE",
  lastName: "USER",
  email: "FakeUser@WebSite.com",
  phone: "0891119595",
  line: "fakeuser",
  role: "user"
}

{:ok, admin1_node} = Account.create_user(admin1)
{:ok, _admin2_node} = Account.create_user(admin2)
{:ok, _user1_node} = Account.create_user(user1)

IO.puts(">>> SEED >>> Test Accounts created!")

#  ************* END: Insert test Accounts **************************************

# ******************* Insert Room ***********************************************
alias Apartman.Facility
alias Apartman.Facility.Relationship.HasRoom

_floor_list =
  1..total_floors
  |> Enum.with_index(1)
  |> Enum.each(fn {_val, index} ->
    # Generate the n-th floor
    floor = %{
      number: Integer.to_string(index)
    }

    {:ok, floor_node} = Facility.create_floor(floor)

    # Generate rooms for that n-th floor
    Enum.each(1..rooms_per_floor, fn room ->
      room_prefix = index * 100

      room = %{
        number: Integer.to_string(room_prefix + room)
      }

      {:ok, room_node} = Facility.create_room(room)

      # Relationship :: (Floor)-[HAS_ROOM]->(Room)
      rel_has_room = %{
        start_node: floor_node,
        end_node: room_node
      }

      {:ok, _has_room} =
        %HasRoom{}
        |> HasRoom.changeset(rel_has_room)
        |> Repo.Relationship.create(rel_has_room)
    end)
  end)

IO.puts(">>> SEED >>> #{total_floors * rooms_per_floor} Rooms created!")
# ***************** END: Insert Room ********************************************

# ************* Insert fake Customers *******************************************

alias Apartman.Tenant
alias Apartman.Tenant.Customer
alias Apartman.Facility.Room
alias Apartman.Account.Relationship.Create

# Generate customers
Enum.each(1..total_customers, fn _customer ->
  customer = %{
    idNumber: Faker.Code.isbn13(),
    firstName: Faker.Name.first_name(),
    lastName: Faker.Name.last_name(),
    dateOfBirth: Date.to_string(Faker.Date.date_of_birth(18..40)),
    faith: Enum.random(["Buddhism", "Christian", "Islam", "Hindu"]),
    nationality: Enum.random(["Thai", "Japanese", "Korean", "Chinese"]),
    sex: Enum.random(["Male", "Female"]),
    address: Faker.Address.En.street_address(true),
    issueBy: Faker.Name.name(),
    dateOfIssue: Date.to_string(Faker.Date.between(~D[1990-01-01], ~D[2000-01-01])),
    dateOfExpiry: Date.to_string(Faker.Date.between(~D[2015-01-01], ~D[2030-01-01])),
    phone: Faker.Phone.EnUs.phone(),
    line: Faker.Team.creature(),
    occupation: Faker.Name.En.title(),
    emergencyContact: Faker.Phone.EnUs.phone()
  }

  {:ok, customer_node} = Tenant.create_customer(customer)

  # Randomly pick a user to 'create' the customer
  creator_node = Enum.random([admin1_node])

  # Relationship :: (User)-[CREATE]->(Customer)
  rel_create_user = %{
    start_node: creator_node,
    end_node: customer_node
  }

  %Create{}
  |> Create.changeset(rel_create_user)
  |> Repo.Relationship.create(rel_create_user)
end)

IO.puts(">>> SEED >>> #{total_customers} Customers created!")

#  ************ END: Insert fake Customers ***************************************

#  ************* Insert fake Bookings ********************************************

alias Bolt.Sips, as: Neo
alias Apartman.Repo
alias Apartman.Booking
alias Apartman.Facility
alias Apartman.Invoice
alias Apartman.Receipt

alias Apartman.Booking.Relationship.{
  OccupyDaily,
  OccupyMonthly,
  CreateReceipt,
  HasDailyInvoice,
  HasMonthlyInvoice,
  HasDailyBookingFee,
  HasMonthlyBookingFee
}

alias Apartman.Tenant.Relationship.{
  RentDaily,
  ReserveDaily,
  SignCheckin,
  RentMonthly,
  ReserveMonthly,
  SignContract
}

conn = Neo.conn()

# Generate total of n-th Bookings
Enum.each(1..total_bookings, fn _total_bookings ->
  # ++++++++++++++++++++++++++++ Booking data ++++++++++++++++++++++++++++
  date_in = Faker.Date.between(~D[2019-01-01], ~D[2019-03-31])
  date_out = Faker.Date.between(~D[2019-05-01], ~D[2020-05-04])
  {:ok, time_in} = Time.new(:rand.uniform(12), :rand.uniform(59), 0, 0)
  rent_fees = Float.to_string(8888 / :rand.uniform(10))
  service_fees = Float.to_string(3333 / :rand.uniform(10))
  deposit = Float.to_string(555 / :rand.uniform(10))
  advance_payment = Float.to_string(444 / :rand.uniform(10))
  keycard_fees = Float.to_string(875 / :rand.uniform(10))

  # Random the type of Customer
  booking_type = Enum.random(["Daily", "Monthly"])
  booking_path = Enum.random(["Walkin", "Pre-Booked"])

  # Get a random Customer
  query_random_customer = "MATCH (c:Customer) RETURN c AS Customer ORDER BY rand() LIMIT 1"
  # Get a random Room
  query_random_room = "MATCH (r:Room) RETURN r.number AS Room ORDER BY rand() LIMIT 1"

  response_random_customer = Neo.query!(conn, query_random_customer)
  response_random_room = Neo.query!(conn, query_random_room)

  query_customer =
    Enum.map(response_random_customer.results, & &1["Customer"])
    |> List.first()

  room_number =
    Enum.map(response_random_room.results, & &1["Room"])
    |> List.first()

  customer_node = Repo.Node.get_by!(Customer, uuid: query_customer.properties["uuid"])
  random_room_node = Repo.Node.get_by!(Room, number: room_number)

  # ++++++++++++++++++++++++++ END Booking data ++++++++++++++*+++++++++++

  # DailyRent
  daily_rent = %{
    b_current: true
  }

  # MonthlyRent
  monthly_rent = %{
    b_current: true,
    b_tenant: true,
    b_contract: true
  }

  # Checkin
  checkin = %{
    checkIn: date_in,
    checkOut: date_out,
    timeIn: time_in,
    roomNumber: room_number,
    from: "Some Country",
    to: "Some Destination"
  }

  # DailyBooking
  daily_booking = %{
    checkIn: date_in,
    checkOut: date_out
  }

  # MonthlyBooking
  monthly_booking = %{
    checkIn: date_in,
    checkOut: date_out,
    rentFees: rent_fees,
    serviceFees: service_fees,
    deposit: deposit,
    advancePayment: advance_payment,
    keycardFees: keycard_fees
  }

  # Contract
  contract = %{
    dateSigned: date_in,
    checkIn: date_in,
    checkOut: date_out,
    rentFees: rent_fees,
    serviceFees: service_fees,
    deposit: deposit,
    advancePayment: advance_payment,
    keycardFees: keycard_fees,
    roomNumber: room_number,
    keycardNumber: Faker.Code.isbn(),
    meterElectric: Float.to_string(223 / :rand.uniform(10)),
    meterWater: Float.to_string(777 / :rand.uniform(10))
  }

  # Receipt
  receipt = %{
    deposit: deposit,
    advancePayment: advance_payment,
    keycardFees: keycard_fees
  }

  # BookingFee
  booking_fee = %{
    bookingFees: Float.to_string(400 / :rand.uniform(10)),
    deposit: Float.to_string(500 / :rand.uniform(10)),
    roomFees: Float.to_string(200 / :rand.uniform(10)),
    total: Float.to_string(200 / :rand.uniform(10) * 5 + 500)
  }

  # DailyInvoice
  daily_invoice = %{
    deposit: deposit,
    roomFees: Float.to_string(200 / :rand.uniform(10)),
    total: Float.to_string(200 / :rand.uniform(10) * 5 + 500)
  }

  # MonthlyInvoice
  monthly_invoice = %{
    billCycle: date_in,
    advancePayment: advance_payment,
    waterStart: Float.to_string(111 / :rand.uniform(10)),
    waterEnd: Float.to_string(222 / :rand.uniform(10)),
    waterUnit: Float.to_string(334 / :rand.uniform(10)),
    electricStart: Float.to_string(447 / :rand.uniform(10)),
    electricEnd: Float.to_string(558 / :rand.uniform(10))
  }

  cond do
    # **********************************************************
    # *                                                        *
    # *                Daily + Walk-in                         *
    # *                                                        *
    # **********************************************************
    booking_type == "Daily" && booking_path == "Walkin" ->
      {:ok, daily_rent_node} = Tenant.create_daily_rent(daily_rent)
      {:ok, checkin_node} = Booking.create_checkin(checkin)
      {:ok, daily_invoice_node} = Invoice.create_daily_invoice(daily_invoice)

      # Relationship :: (Customer)-[RENT_DAILY]->(DailyRent)
      rel_rent_daily = %{
        start_node: customer_node,
        end_node: daily_rent_node
      }

      {:ok, _rent_daily} =
        %RentDaily{}
        |> RentDaily.changeset(rel_rent_daily)
        |> Repo.Relationship.create(rel_rent_daily)

      # Relationship :: (DailyRent)-[WALKIN_DAILY]->(Checkin)
      rel_walkin_daily = %{
        start_node: daily_rent_node,
        end_node: checkin_node
      }

      {:ok, _walkin_daily} =
        %SignCheckin{}
        |> SignCheckin.changeset(rel_walkin_daily)
        |> Repo.Relationship.create(rel_walkin_daily)

      # Relationship :: (Checkin)-[OCCUPY_DAILY]->(Room)
      rel_occu_room_daily = %{
        start_node: checkin_node,
        end_node: random_room_node,
        dateFirst: date_in,
        dateLast: date_out
      }

      {:ok, _occu_room_daily} =
        %OccupyDaily{}
        |> OccupyDaily.changeset(rel_occu_room_daily)
        |> Repo.Relationship.create(rel_occu_room_daily)

      # Update the Room's status
      update_room_data = %{
        bOccupied: true
      }

      {:ok, _room_node} = Facility.update_room(random_room_node, update_room_data)

      # Relationship :: (Checkin)-[CREATE_DAILY_INVOICE]->(DailyInvoice)
      rel_daily_invoice = %{
        start_node: checkin_node,
        end_node: daily_invoice_node
      }

      {:ok, _daily_invoice} =
        %HasDailyInvoice{}
        |> HasDailyInvoice.changeset(rel_daily_invoice)
        |> Repo.Relationship.create(rel_daily_invoice)

    # **********************************************************
    # *                                                        *
    # *                Daily + Pre-booked                      *
    # *                                                        *
    # **********************************************************
    booking_type == "Daily" && booking_path == "Pre-Booked" ->
      {:ok, daily_rent_node} = Tenant.create_daily_rent(daily_rent)
      {:ok, daily_booking_node} = Booking.create_daily_booking(daily_booking)
      {:ok, checkin_node} = Booking.create_checkin(checkin)
      {:ok, booking_fee_node} = Invoice.create_booking_fee(booking_fee)
      {:ok, daily_invoice_node} = Invoice.create_daily_invoice(daily_invoice)

      # Relationship :: (DailyBooking)-[SIGN_CHECKIN]->(Checkin)
      rel_book_daily = %{
        start_node: daily_booking_node,
        end_node: checkin_node
      }

      {:ok, _book_daily} =
        %Booking.Relationship.SignCheckin{}
        |> Booking.Relationship.SignCheckin.changeset(rel_book_daily)
        |> Repo.Relationship.create(rel_book_daily)

      # Relationship :: (Customer)-[RENT_DAILY]->(DailyRent)
      rel_rent_daily = %{
        start_node: customer_node,
        end_node: daily_rent_node
      }

      {:ok, _rent_daily} =
        %RentDaily{}
        |> RentDaily.changeset(rel_rent_daily)
        |> Repo.Relationship.create(rel_rent_daily)

      # Relationship :: (DailyRent)-[WALKIN_DAILY]->(Checkin)
      rel_prebook_daily = %{
        start_node: daily_rent_node,
        end_node: daily_booking_node
      }

      {:ok, _prebook_daily} =
        %ReserveDaily{}
        |> ReserveDaily.changeset(rel_prebook_daily)
        |> Repo.Relationship.create(rel_prebook_daily)

      # Relationship :: (Checkin)-[OCCUPY_DAILY]->(Room)
      rel_occu_room_daily = %{
        start_node: checkin_node,
        end_node: random_room_node,
        dateFirst: date_in,
        dateLast: date_out
      }

      {:ok, _occu_room_daily} =
        %OccupyDaily{}
        |> OccupyDaily.changeset(rel_occu_room_daily)
        |> Repo.Relationship.create(rel_occu_room_daily)

      # Update the Room's status
      update_room_data = %{
        bOccupied: true
      }

      {:ok, _room_node} = Facility.update_room(random_room_node, update_room_data)

      # Relationship :: (Checkin)-[CREATE_DAILY_INVOICE]->(DailyInvoice)
      rel_daily_invoice = %{
        start_node: checkin_node,
        end_node: daily_invoice_node
      }

      {:ok, _daily_invoice} =
        %HasDailyInvoice{}
        |> HasDailyInvoice.changeset(rel_daily_invoice)
        |> Repo.Relationship.create(rel_daily_invoice)

      # Relationship :: (DailyBooking)-[HAS_DAILY_BOOKING_FEES]->(BookingFee)
      rel_booking_fee = %{
        start_node: daily_booking_node,
        end_node: booking_fee_node
      }

      {:ok, _daily_booking_fee} =
        %HasDailyBookingFee{}
        |> HasDailyBookingFee.changeset(rel_booking_fee)
        |> Repo.Relationship.create(rel_booking_fee)

    # **********************************************************
    # *                                                        *
    # *                Monthly + Walk-in                       *
    # *                                                        *
    # **********************************************************
    booking_type == "Monthly" && booking_path == "Walkin" ->
      {:ok, monthly_rent_node} = Tenant.create_monthly_rent(monthly_rent)
      {:ok, contract_node} = Booking.create_contract(contract)
      {:ok, receipt_node} = Receipt.create_contract_fee(receipt)
      {:ok, monthly_invoice_node} = Invoice.create_monthly_invoice(monthly_invoice)

      # Relationship :: (Customer)-[RENT_MONTHLY]->(MonthlyRent)
      rel_rent_monthly = %{
        start_node: customer_node,
        end_node: monthly_rent_node
      }

      {:ok, _rent_monthly} =
        %RentMonthly{}
        |> RentMonthly.changeset(rel_rent_monthly)
        |> Repo.Relationship.create(rel_rent_monthly)

      # Relationship :: (MonthlyRent)-[WALKIN_MONTHLY]->(Contract)
      rel_walkin_monthly = %{
        start_node: monthly_rent_node,
        end_node: contract_node
      }

      {:ok, _walkin_monthly} =
        %SignContract{}
        |> SignContract.changeset(rel_walkin_monthly)
        |> Repo.Relationship.create(rel_walkin_monthly)

      # Relationship :: (Contract)-[OCCUPY_MONTHLY]->(Room)
      rel_occu_room_monthly = %{
        start_node: contract_node,
        end_node: random_room_node,
        dateFirst: date_in,
        dateLast: date_out
      }

      {:ok, _occu_room_monthly} =
        %OccupyMonthly{}
        |> OccupyMonthly.changeset(rel_occu_room_monthly)
        |> Repo.Relationship.create(rel_occu_room_monthly)

      # Update the Room's status
      update_room_data = %{
        bOccupied: true
      }

      {:ok, _room_node} = Facility.update_room(random_room_node, update_room_data)

      # Relationship :: (Contract)-[CREATE_CONTRACT_RECEIPT]->(Receipt)
      rel_create_contract_receipt = %{
        start_node: contract_node,
        end_node: receipt_node
      }

      {:ok, _receipt} =
        %CreateReceipt{}
        |> CreateReceipt.changeset(rel_create_contract_receipt)
        |> Repo.Relationship.create(rel_create_contract_receipt)

      # Relationship :: (Contract)-[CREATE_MONTHLY_INVOICE]->(MonthlyInvoice)
      rel_monthly_invoice = %{
        start_node: contract_node,
        end_node: monthly_invoice_node
      }

      {:ok, _monthly_invoice} =
        %HasMonthlyInvoice{}
        |> HasMonthlyInvoice.changeset(rel_monthly_invoice)
        |> Repo.Relationship.create(rel_monthly_invoice)

    # **********************************************************
    # *                                                        *
    # *                Monthly + Pre-booked                    *
    # *                                                        *
    # **********************************************************
    booking_type == "Monthly" && booking_path == "Pre-Booked" ->
      {:ok, monthly_rent_node} = Tenant.create_monthly_rent(monthly_rent)
      {:ok, monthly_booking_node} = Booking.create_monthly_booking(monthly_booking)
      {:ok, contract_node} = Booking.create_contract(contract)
      {:ok, receipt_node} = Receipt.create_contract_fee(receipt)
      {:ok, booking_fee_node} = Invoice.create_booking_fee(booking_fee)
      {:ok, monthly_invoice_node} = Invoice.create_monthly_invoice(monthly_invoice)

      # Relationship :: (MonthlyBooking)-[SIGN_CONTRACT]->(Contract)
      rel_book_monthly = %{
        start_node: monthly_booking_node,
        end_node: contract_node
      }

      {:ok, _book_monthly} =
        %Booking.Relationship.SignContract{}
        |> Booking.Relationship.SignContract.changeset(rel_book_monthly)
        |> Repo.Relationship.create(rel_book_monthly)

      # Relationship :: (Customer)-[RENT_MONTHLY]->(MonthlyRent)
      rel_rent_monthly = %{
        start_node: customer_node,
        end_node: monthly_rent_node
      }

      {:ok, _rent_monthly} =
        %RentMonthly{}
        |> RentMonthly.changeset(rel_rent_monthly)
        |> Repo.Relationship.create(rel_rent_monthly)

      # Relationship :: (MonthlyRent)-[WALKIN_MONTHLY]->(Contract)
      rel_prebook_monthly = %{
        start_node: monthly_rent_node,
        end_node: monthly_booking_node
      }

      {:ok, _prebook_monthly} =
        %ReserveMonthly{}
        |> ReserveMonthly.changeset(rel_prebook_monthly)
        |> Repo.Relationship.create(rel_prebook_monthly)

      # Relationship :: (Contract)-[OCCUPY_MONTHLY]->(Room)
      rel_occu_room_monthly = %{
        start_node: contract_node,
        end_node: random_room_node,
        dateFirst: date_in,
        dateLast: date_out
      }

      {:ok, _occu_room_monthly} =
        %OccupyMonthly{}
        |> OccupyMonthly.changeset(rel_occu_room_monthly)
        |> Repo.Relationship.create(rel_occu_room_monthly)

      # Update the Room's status
      update_room_data = %{
        bOccupied: true
      }

      {:ok, _room_node} = Facility.update_room(random_room_node, update_room_data)

      # Relationship :: (Contract)-[CREATE_CONTRACT_RECEIPT]->(Receipt)
      rel_create_contract_receipt = %{
        start_node: contract_node,
        end_node: receipt_node
      }

      {:ok, _receipt} =
        %CreateReceipt{}
        |> CreateReceipt.changeset(rel_create_contract_receipt)
        |> Repo.Relationship.create(rel_create_contract_receipt)

      # Relationship :: (Contract)-[CREATE_MONTHLY_INVOICE]->(MonthlyInvoice)
      rel_monthly_invoice = %{
        start_node: contract_node,
        end_node: monthly_invoice_node
      }

      {:ok, _monthly_invoice} =
        %HasMonthlyInvoice{}
        |> HasMonthlyInvoice.changeset(rel_monthly_invoice)
        |> Repo.Relationship.create(rel_monthly_invoice)

      # Relationship :: (DailyBooking)-[HAS_DAILY_BOOKING_FEES]->(BookingFee)
      rel_booking_fee = %{
        start_node: monthly_booking_node,
        end_node: booking_fee_node
      }

      {:ok, _monthly_booking_fee} =
        %HasMonthlyBookingFee{}
        |> HasMonthlyBookingFee.changeset(rel_booking_fee)
        |> Repo.Relationship.create(rel_booking_fee)
  end
end)

IO.puts(">>> SEED >>> #{total_bookings} Bookings created!")
#  ************ END: Insert fake Bookings ***************************************

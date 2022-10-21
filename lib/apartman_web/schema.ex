defmodule ApartmanWeb.Schema do
  use Absinthe.Schema

  alias ApartmanWeb.Resolvers

  # Import Types
  import_types(ApartmanWeb.Schema.Types)

  query do
    # |++++++++++++++++++++++++++++ Account ++++++++++++++++++++++++++++|

    @desc "[Account] List all Users"
    field :users, list_of(:user_type) do
      resolve(&Resolvers.AccountResolver.users/3)
    end

    @desc "[Account] Get a User"
    field :user, :user_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.AccountResolver.user/3)
    end

    # |++++++++++++++++++++++++++++ Tenant  ++++++++++++++++++++++++++++|

    @desc "[Tenant] List all Customers"
    field :customers, list_of(:customer_type) do
      resolve(&Resolvers.TenantResolver.customers/3)
    end

    @desc "[Tenant] Get a Customer"
    field :customer, :customer_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.TenantResolver.customer/3)
    end

    @desc "[Tenant] Find a Customer by ID-Card Number"
    field :customer_by_id, :customer_type do
      arg(:id_number, non_null(:string))
      resolve(&Resolvers.TenantResolver.customer_id_number/3)
    end

    @desc "[Tenant] List all Daily-Rents"
    field :daily_rents, list_of(:daily_rent_type) do
      resolve(&Resolvers.TenantResolver.daily_rents/3)
    end

    @desc "[Tenant] Get a Daily-Rent"
    field :daily_rent, :daily_rent_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.TenantResolver.daily_rent/3)
    end

    @desc "[Tenant] List all Monthly-Rents"
    field :monthly_rents, list_of(:monthly_rent_type) do
      resolve(&Resolvers.TenantResolver.monthly_rents/3)
    end

    @desc "[Tenant] Get a Monthly-Rent"
    field :monthly_rent, :monthly_rent_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.TenantResolver.monthly_rent/3)
    end

    # |++++++++++++++++++++++++++++ Booking  ++++++++++++++++++++++++++++|

    @desc "[Booking] List all Check-ins"
    field :checkins, list_of(:checkin_type) do
      resolve(&Resolvers.BookingResolver.checkins/3)
    end

    @desc "[Booking] Get a Check-in"
    field :checkin, :checkin_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.BookingResolver.checkin/3)
    end

    @desc "[Booking] List all Contracts"
    field :contracts, list_of(:contract_type) do
      resolve(&Resolvers.BookingResolver.contracts/3)
    end

    @desc "[Booking] Get a Contract"
    field :contract, :contract_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.BookingResolver.contract/3)
    end

    @desc "[Booking] List all Daily-Bookings"
    field :daily_bookings, list_of(:daily_booking_type) do
      resolve(&Resolvers.BookingResolver.daily_bookings/3)
    end

    @desc "[Booking] Get a Daily-Booking"
    field :daily_booking, :daily_booking_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.BookingResolver.daily_booking/3)
    end

    @desc "[Booking] List all Monthly-Bookings"
    field :monthly_bookings, list_of(:monthly_booking_type) do
      resolve(&Resolvers.BookingResolver.monthly_bookings/3)
    end

    @desc "[Booking] Get a Monthly-Booking"
    field :monthly_booking, :monthly_booking_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.BookingResolver.monthly_booking/3)
    end

    # |++++++++++++++++++++++++++++ Receipt ++++++++++++++++++++++++++++|

    @desc "[Receipt] List all Contract-Fees Receipts"
    field :contract_fees, list_of(:contract_fee_type) do
      resolve(&Resolvers.ReceiptResolver.contract_fees/3)
    end

    @desc "[Receipt] Get a Contract-Fees Receipt"
    field :contract_fee, :contract_fee_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.ReceiptResolver.contract_fee/3)
    end

    # |++++++++++++++++++++++++++++ Invoice ++++++++++++++++++++++++++++|

    @desc "[Invoice] List all Booking-Fees Invoices"
    field :booking_fees, list_of(:booking_fee_type) do
      resolve(&Resolvers.InvoiceResolver.booking_fees/3)
    end

    @desc "[Invoice] Get a Booking-Fees Invoice"
    field :booking_fee, :booking_fee_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.InvoiceResolver.booking_fee/3)
    end

    @desc "[Invoice] List all Daily-Invoices"
    field :daily_invoices, list_of(:daily_invoice_type) do
      resolve(&Resolvers.InvoiceResolver.daily_invoices/3)
    end

    @desc "[Invoice] Get a Daily-Invoice"
    field :daily_invoice, :daily_invoice_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.InvoiceResolver.daily_invoice/3)
    end

    @desc "[Invoice] List all Monthly-Invoices"
    field :monthly_invoices, list_of(:monthly_invoice_type) do
      resolve(&Resolvers.InvoiceResolver.monthly_invoices/3)
    end

    @desc "[Invoice] Get a Monthly-Invoice"
    field :monthly_invoice, :monthly_invoice_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.InvoiceResolver.monthly_invoice/3)
    end

    # |+++++++++++++++++++++++++++ Facility +++++++++++++++++++++++++++|

    @desc "[Facility] List all Buildings"
    field :buildings, list_of(:building_type) do
      resolve(&Resolvers.FacilityResolver.buildings/3)
    end

    @desc "[Facility] Get a Building"
    field :building, :building_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.FacilityResolver.building/3)
    end

    @desc "[Facility] List all Floors"
    field :floors, list_of(:floor_type) do
      resolve(&Resolvers.FacilityResolver.floors/3)
    end

    @desc "[Facility] Get a Floor"
    field :floor, :floor_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.FacilityResolver.floor/3)
    end

    @desc "[Facility] List all Rooms"
    field :rooms, list_of(:room_type) do
      resolve(&Resolvers.FacilityResolver.rooms/3)
    end

    @desc "[Facility] Get a Room"
    field :room, :room_type do
      arg(:id, non_null(:id))
      resolve(&Resolvers.FacilityResolver.room/3)
    end
  end

  mutation do
    # |++++++++++++++++++++++++++++ Account ++++++++++++++++++++++++++++|

    @desc "[Account] Create a new user"
    field :user_create, type: :user_type do
      arg(:input, non_null(:user_create_type))
      resolve(&Resolvers.AccountResolver.register/3)
    end

    @desc "[Account] Update the user info"
    field :user_update, type: :user_type do
      arg(:id, non_null(:string))
      arg(:input, :user_update_type)
      resolve(&Resolvers.AccountResolver.update/3)
    end

    @desc "[Account] Delete the user (and all relationships)"
    field :user_delete, type: :user_type do
      arg(:id, non_null(:string))
      resolve(&Resolvers.AccountResolver.delete/3)
    end

    # |++++++++++++++++++++++++++++ Tenant  ++++++++++++++++++++++++++++|

    @desc "[Tenant] Create a new customer"
    field :customer_create, type: :customer_type do
      arg(:input, non_null(:customer_create_type))
      resolve(&Resolvers.TenantResolver.create_customer/3)
    end

    @desc "[Tenant] Update the customer info"
    field :customer_update, type: :customer_type do
      arg(:id, non_null(:string))
      arg(:input, :customer_update_type)
      resolve(&Resolvers.TenantResolver.update_customer/3)
    end

    @desc "[Tenant] Delete the customer (and all relationships)"
    field :customer_delete, type: :customer_type do
      arg(:id, non_null(:string))
      resolve(&Resolvers.TenantResolver.delete_customer/3)
    end
  end

  # subscription do
  # end
end

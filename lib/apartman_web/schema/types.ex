defmodule ApartmanWeb.Schema.Types do
  use Absinthe.Schema.Notation

  alias ApartmanWeb.Schema.Types

  import_types(Types.AccountType)
  import_types(Types.TenantType)
  import_types(Types.BookingType)
  import_types(Types.ReceiptType)
  import_types(Types.FacilityType)
  import_types(Types.InvoiceType)
end

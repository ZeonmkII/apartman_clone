defmodule ApartmanWeb.Schema.Types.TenantType do
  use Absinthe.Schema.Notation

  object :customer_type do
    field :id, :string
    field :id_number, :string
    field :first_name, :string
    field :last_name, :string
    field :first_name_alt, :string
    field :last_name_alt, :string
    field :date_of_birth, :string
    field :faith, :string
    field :nationality, :string
    field :gender, :string
    field :address, :string
    field :issue_by, :string
    field :date_of_issue, :string
    field :date_of_expiry, :string
    field :photo, :string
    field :phone, :string
    field :line, :string
    field :occupation, :string
    field :emergency_contact, :string
  end

  input_object :customer_create_type do
    field :parent_id, non_null(:string)
    field :id_number, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :phone, non_null(:string)
    field :date_of_birth, :string
    field :faith, :string
    field :nationality, :string
    field :gender, :string
    field :address, :string
    field :issue_by, :string
    field :date_of_issue, :string
    field :date_of_expiry, :string
    field :photo, :string
    field :line, :string
    field :occupation, :string
    field :emergency_contact, :string
  end

  input_object :customer_update_type do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :date_of_birth, :string
    field :faith, :string
    field :nationality, :string
    field :gender, :string
    field :address, :string
    field :issue_by, :string
    field :date_of_issue, :string
    field :date_of_expiry, :string
    field :photo, :string
    field :line, :string
    field :occupation, :string
    field :emergency_contact, :string
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  object :daily_rent_type do
    field :id, :string
    field :b_current, :boolean
  end

  input_object :daily_rent_input_type do
    field :parent_id, non_null(:string)
    field :b_current, :boolean
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  object :monthly_rent_type do
    field :id, :string
    field :b_current, :boolean
    field :b_tenant, :boolean
    field :b_contract, :boolean
  end

  input_object :monthly_rent_input_type do
    field :parent_id, non_null(:string)
    field :b_current, :boolean
    field :b_tenant, :boolean
    field :b_contract, :boolean
  end
end

defmodule ApartmanWeb.Schema.Types.AccountType do
  use Absinthe.Schema.Notation

  object :user_type do
    field :id, :string
    field :user_name, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :line, :string
    field :role, :string
    field :b_active, :boolean
  end

  input_object :user_create_type do
    field :user_name, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :email, :string
    field :phone, :string
    field :line, :string
    field :role, :string
    field :b_active, :boolean
  end

  input_object :user_update_type do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :line, :string
    field :role, :string
    field :b_active, :boolean
  end
end

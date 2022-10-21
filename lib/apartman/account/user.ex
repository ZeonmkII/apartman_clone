defmodule Apartman.Account.User do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Account.Relationship.Create
  alias Apartman.Tenant.Customer

  node "User" do
    property(:userName, :string)
    property(:password, :string, virtual: true)
    property(:passwordHash, :string)
    property(:firstName, :string)
    property(:lastName, :string)
    property(:email, :string)
    property(:phone, :string)
    property(:line, :string)
    property(:role, :string, default: "user")
    property(:bActive, :boolean, default: false)

    outgoing_relationship("CREATE", Customer, :creates, Create, cardinality: :many)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :uuid,
      :userName,
      :password,
      :firstName,
      :lastName,
      :email,
      :phone,
      :line,
      :role,
      :bActive
    ])
    |> validate_required([
      :userName,
      :password,
      :firstName,
      :lastName
    ])
    |> validate_format(:email, ~r/@/)
    |> downcase_email()
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "Confirmation doesn't match!", required: false)
    |> hash_password()
  end

  def updateset(user, attrs) do
    user
    |> cast(attrs, [
      :firstName,
      :lastName,
      :email,
      :phone,
      :line,
      :role,
      :bActive
    ])
    |> validate_format(:email, ~r/@/)
    |> downcase_email()
  end

  # defp downcase_email(%Seraph.Changeset{valid?: true, changes: %{email: _email}} = changeset) do
  #   update_change(changeset, :email, &String.downcase/1)
  # end

  # defp downcase_email(changeset), do: changeset

  defp downcase_email(changeset) do
    email = get_field(changeset, :email)

    if is_nil(email) do
      changeset
    else
      update_change(changeset, :email, &String.downcase/1)
    end
  end

  # defp hash_password(%Seraph.Changeset{valid?: true, changes: %{password: password}} = changeset) do
  #   change(changeset, Pbkdf2.add_hash(password))
  # end

  # defp hash_password(changeset), do: changeset

  defp hash_password(changeset) do
    password = get_field(changeset, :password)
    secret = Pbkdf2.add_hash(password)
    put_change(changeset, :passwordHash, secret.password_hash)
  end
end

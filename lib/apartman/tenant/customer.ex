defmodule Apartman.Tenant.Customer do
  use Seraph.Schema.Node
  import Seraph.Changeset

  alias Apartman.Account.User
  alias Apartman.Account.Relationship.Create
  alias Apartman.Tenant.Relationship.{RentDaily, RentMonthly}

  node "Customer" do
    property(:idNumber, :string)
    property(:firstName, :string)
    property(:firstNameAlt, :string)
    property(:lastName, :string)
    property(:lastNameAlt, :string)
    property(:dateOfBirth, :string)
    property(:faith, :string)
    property(:nationality, :string)
    property(:sex, :string)
    property(:address, :string)
    property(:issueBy, :string)
    property(:dateOfIssue, :string)
    property(:dateOfExpiry, :string)
    property(:photo, :string)
    property(:phone, :string)
    property(:line, :string)
    property(:occupation, :string)
    property(:emergencyContact, :string)

    incoming_relationship("CREATE", User, :creator, Create, cardinality: :one)

    outgoing_relationship("RENT_DAILY", Customer, :rents_daily, RentDaily, cardinality: :many)

    outgoing_relationship("RENT_MONTHLY", Customer, :rents_monthly, RentMonthly,
      cardinality: :many
    )
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [
      :uuid,
      :idNumber,
      :firstName,
      :lastName,
      :firstNameAlt,
      :lastNameAlt,
      :dateOfBirth,
      :faith,
      :nationality,
      :sex,
      :address,
      :issueBy,
      :dateOfIssue,
      :dateOfExpiry,
      :photo,
      :phone,
      :line,
      :occupation,
      :emergencyContact
    ])
    |> validate_required([:idNumber, :firstName, :lastName, :phone])
    |> reformat_date(:dateOfBirth)
    |> reformat_date(:dateOfIssue)
    |> reformat_date(:dateOfExpiry)
    |> add_photo()
  end

  defp reformat_date(changeset, field) do
    date = get_field(changeset, field)

    case is_nil(date) do
      true ->
        changeset

      false ->
        case Date.from_iso8601(date) do
          {:ok, date} ->
            put_change(changeset, field, date)

          {:error, _} ->
            case Timex.parse(date, "{D}-{0M}-{YYYY}") do
              {:ok, timex_date} ->
                date = Timex.to_date(timex_date)
                put_change(changeset, field, date)

              {:error, _} ->
                raise "::HORPAK_ERROR:: Invalid DATE format"
            end
        end
    end
  end

  defp add_photo(changeset) do
    idNumber = get_field(changeset, :idNumber)
    put_change(changeset, :photo, idNumber <> ".jpg")
  end
end

defmodule Apartman.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :idNumber, :string
      add :firstName, :string
      add :firstNameAlt, :string
      add :lastName, :string
      add :lastNameAlt, :string
      add :datOfBirth, :date
      add :faith, :string
      add :nationality, :string
      add :sex, :string
      add :address, :string
      add :issueBy, :string
      add :dateOfIssue, :date
      add :dateOfExpiry, :date
      add :photo, :string
      add :phone, :string
      add :line, :string
      add :occupation, :string
      add :emergencyContact, :string

      timestamps()
    end

  end
end

defmodule Apartman.Repo.Migrations.CreateMonthlyinvoices do
  use Ecto.Migration

  def change do
    create table(:monthlyinvoices) do
      add :billCycle, :date
      add :advancePayment, :string
      add :waterStart, :string
      add :waterEnd, :string
      add :waterUnit, :string
      add :electricStart, :string
      add :eletricEnd, :string
      add :otherLabels, :string
      add :otherFees, :string

      timestamps()
    end

  end
end

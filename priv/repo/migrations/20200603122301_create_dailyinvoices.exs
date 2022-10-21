defmodule Apartman.Repo.Migrations.CreateDailyinvoices do
  use Ecto.Migration

  def change do
    create table(:dailyinvoices) do
      add :deposit, :string
      add :advancePayment, :string
      add :keycardFees, :string
      add :otherLabels, :string
      add :otherFees, :string

      timestamps()
    end

  end
end

defmodule Apartman.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :contractId, :string
      add :dateSigned, :date
      add :checkIn, :date
      add :checkOut, :date
      add :durationMonth, :integer
      add :durationDay, :integer
      add :roomNumber, :string
      add :rentFees, :string
      add :serviceFees, :string
      add :deposit, :string
      add :advancePayment, :string
      add :keycardFees, :string
      add :keycardNumber, :string
      add :otherLabels, :string
      add :otherFees, :string
      add :meterWater, :float
      add :meterElectric, :float
      add :remarks, :string

      timestamps()
    end

  end
end

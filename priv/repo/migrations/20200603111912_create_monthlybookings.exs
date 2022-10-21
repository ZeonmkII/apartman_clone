defmodule Apartman.Repo.Migrations.CreateMonthlybookings do
  use Ecto.Migration

  def change do
    create table(:monthlybookings) do
      add :bookingId, :string
      add :checkIn, :date
      add :checkOut, :date
      add :durationMonth, :integer
      add :durationDay, :integer
      add :remarks, :string
      add :rentFees, :string
      add :serviceFees, :string
      add :deposit, :string
      add :advancePayment, :string
      add :keycardFees, :string
      add :otherLabels, :string
      add :otherFees, :string

      timestamps()
    end

  end
end

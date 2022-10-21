defmodule Apartman.Repo.Migrations.CreateDailybookings do
  use Ecto.Migration

  def change do
    create table(:dailybookings) do
      add :bookingId, :string
      add :checkIn, :date
      add :checkOut, :date
      add :durationDay, :integer
      add :remarks, :string

      timestamps()
    end

  end
end

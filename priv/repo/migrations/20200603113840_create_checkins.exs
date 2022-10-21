defmodule Apartman.Repo.Migrations.CreateCheckins do
  use Ecto.Migration

  def change do
    create table(:checkins) do
      add :checkIn, :date
      add :checkOut, :date
      add :timeIn, :time
      add :timeOut, :time
      add :durationDay, :integer
      add :roomNumber, :string
      add :deposit, :string
      add :from, :string
      add :to, :string
      add :remarks, :string

      timestamps()
    end

  end
end

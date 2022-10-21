defmodule Apartman.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :number, :string
      add :bBooked, :boolean, default: false, null: false
      add :bOccupied, :boolean, default: false, null: false

      timestamps()
    end

  end
end

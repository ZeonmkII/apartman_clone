defmodule Apartman.Repo.Migrations.CreateFloors do
  use Ecto.Migration

  def change do
    create table(:floors) do
      add :number, :string

      timestamps()
    end

  end
end

defmodule Apartman.Repo.Migrations.CreateBuildings do
  use Ecto.Migration

  def change do
    create table(:buildings) do
      add :name, :string
      add :address, :string
      add :taxId, :string
      add :phone, :string
      add :calcTypeWater, :string
      add :calcTypeElectric, :string
      add :unitPriceWater, :string
      add :unitPriceElectric, :string

      timestamps()
    end

  end
end

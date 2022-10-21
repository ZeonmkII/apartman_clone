defmodule Apartman.Repo.Migrations.CreateMonthlyrents do
  use Ecto.Migration

  def change do
    create table(:monthlyrents) do
      add :bCurrent, :boolean, default: false, null: false
      add :bTenant, :boolean, default: false, null: false
      add :bContract, :boolean, default: false, null: false

      timestamps()
    end

  end
end

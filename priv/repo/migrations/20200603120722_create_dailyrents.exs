defmodule Apartman.Repo.Migrations.CreateDailyrents do
  use Ecto.Migration

  def change do
    create table(:dailyrents) do
      add :bCurrent, :boolean, default: false, null: false

      timestamps()
    end

  end
end

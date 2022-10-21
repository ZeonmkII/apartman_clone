defmodule Apartman.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :passwordConfirmation, :string
      add :passwordHash, :string
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :phone, :string
      add :line, :string
      add :role, :string
      add :bActive, :boolean, default: false, null: false

      timestamps()
    end

  end
end

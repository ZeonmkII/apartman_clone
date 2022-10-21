defmodule Apartman.Repo.Migrations.CreateBookingfees do
  use Ecto.Migration

  def change do
    create table(:bookingfees) do
      add :bookingFees, :string

      timestamps()
    end

  end
end

defmodule Scrapper.Repo.Migrations.CreateDataSource do
  use Ecto.Migration

  def change do
    create table(:data_source) do
      add :name, :string
      add :last_rub_at, :utc_datetime_usec

      timestamps()
    end

  end
end

defmodule Scrapper.Repo.Migrations.CreateDataSource do
  use Ecto.Migration

  def change do
    create table(:data_sources) do
      add :name, :string
      add :last_run_at, :utc_datetime_usec

      timestamps()
    end

  end
end

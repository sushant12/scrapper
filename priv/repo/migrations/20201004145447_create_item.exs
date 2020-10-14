defmodule Scrapper.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :text
      add :image, :string
      add :price, :string
      add :data_source_id, references(:data_sources, on_delete: :delete_all)
      timestamps()
    end
    create unique_index(:items, [:name, :data_source_id])
  end
end

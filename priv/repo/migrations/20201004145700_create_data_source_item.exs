defmodule Scrapper.Repo.Migrations.CreateDataSourceItem do
  use Ecto.Migration

  def change do
    create table(:data_source_items) do
      add :data_source_id, references(:data_source, on_delete: :delete_all)
      add :item_id, references(:item, on_delete: :delete_all)
    end

    create unique_index(:data_source_items, [:data_source_id, :item_id])
  end
end

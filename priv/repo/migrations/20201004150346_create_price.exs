defmodule Scrapper.Repo.Migrations.CreatePrice do
  use Ecto.Migration

  def change do
    create table(:price) do
      add :price, :string
      add :created_at, :date
      add :item_id, references(:items, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:price, [:item_id, :created_at])
  end
end

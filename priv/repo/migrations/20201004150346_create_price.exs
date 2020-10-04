defmodule Scrapper.Repo.Migrations.CreatePrice do
  use Ecto.Migration

  def change do
    create table(:price) do
      add :price, :float
      add :item_id, references(:item, on_delete: :nothing)

      timestamps()
    end

    create index(:price, [:item_id])
  end
end

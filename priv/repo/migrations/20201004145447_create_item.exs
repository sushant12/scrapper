defmodule Scrapper.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add :name, :string
      add :description, :string
      add :image, :string

      timestamps()
    end

  end
end

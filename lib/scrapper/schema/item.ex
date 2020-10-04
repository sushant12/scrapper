defmodule Scrapper.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrapper.Schema.DataSource
  schema "item" do
    field :description, :string
    field :image, :string
    field :name, :string
    many_to_many(:data_source, DataSource, join_through: "data_source_items")

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :image])
    |> validate_required([:name])
  end
end

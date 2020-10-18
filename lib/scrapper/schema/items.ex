defmodule Scrapper.Schema.Items do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrapper.Schema.DataSources

  schema "items" do
    field :description, :string
    field :image, :string
    field :name, :string
    field :price, :string
    belongs_to(:data_sources, DataSources)

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :image, :price])
    |> validate_required([:name])
  end
end

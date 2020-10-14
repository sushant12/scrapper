defmodule Scrapper.Schema.Price do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrapper.Schema.Items

  schema "price" do
    field :price, :string
    field :created_at, :date
    belongs_to :item, Items
    timestamps()
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:price, :created_at, :item_id])
  end
end

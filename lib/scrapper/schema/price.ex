defmodule Scrapper.Schema.Price do
  use Ecto.Schema
  import Ecto.Changeset

  schema "price" do
    field :price, :float
    field :item_id, :id

    timestamps()
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:price, :item_id])
    |> validate_required([:price, :item_id])
  end
end

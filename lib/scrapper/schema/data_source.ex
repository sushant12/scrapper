defmodule Scrapper.Schema.DataSource do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrapper.Schema.Item
  schema "data_source" do
    field :last_rub_at, :utc_datetime_usec
    field :name, :string
    many_to_many(:item, Item, join_through: "data_source_items")
    timestamps()
  end

  @doc false
  def changeset(data_source, attrs) do
    data_source
    |> cast(attrs, [:name, :last_rub_at])
    |> validate_required([:name])
  end
end

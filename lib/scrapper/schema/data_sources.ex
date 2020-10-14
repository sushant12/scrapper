defmodule Scrapper.Schema.DataSources do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrapper.Schema.Items

  schema "data_sources" do
    field :last_run_at, :utc_datetime_usec
    field :name, :string
    has_many(:items, Items)
    timestamps()
  end

  @doc false
  def changeset(data_source, attrs) do
    data_source
    |> cast(attrs, [:name, :last_run_at])
    |> validate_required([:name])
  end
end

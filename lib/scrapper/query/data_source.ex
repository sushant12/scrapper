defmodule Scrapper.Query.DataSource do
  alias Scrapper.Repo
  alias Scrapper.Schema.DataSources

  def create_data_source(attrs \\ %{}) do
    %DataSources{}
    |> DataSources.changeset(attrs)
    |> Repo.insert()
  end

  def get_data_source(name) do
    Repo.get_by!(DataSources, name: name)
  end

  def list_data_sources do
    Repo.all(DataSources)
  end

  def update_data_source(%DataSources{} = data_source, attrs) do
    data_source
    |> DataSources.changeset(attrs)
    |> Repo.update!()
  end
end

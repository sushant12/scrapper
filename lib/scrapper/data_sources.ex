defmodule Scrapper.DataSources do
  @moduledoc """
  The DataSources context.
  """

  import Ecto.Query, warn: false
  alias Scrapper.Repo

  alias Scrapper.Schema.DataSource

  @doc """
  Returns the list of data_source.

  ## Examples

      iex> list_data_source()
      [%DataSource{}, ...]

  """
  def list_data_source do
    Repo.all(DataSource)
  end

  @doc """
  Gets a single data_source.

  Raises `Ecto.NoResultsError` if the Data source does not exist.

  ## Examples

      iex> get_data_source!(123)
      %DataSource{}

      iex> get_data_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_data_source!(id), do: Repo.get!(DataSource, id)

  @doc """
  Creates a data_source.

  ## Examples

      iex> create_data_source(%{field: value})
      {:ok, %DataSource{}}

      iex> create_data_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_data_source(attrs \\ %{}) do
    %DataSource{}
    |> DataSource.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a data_source.

  ## Examples

      iex> update_data_source(data_source, %{field: new_value})
      {:ok, %DataSource{}}

      iex> update_data_source(data_source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_data_source(%DataSource{} = data_source, attrs) do
    data_source
    |> DataSource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a data_source.

  ## Examples

      iex> delete_data_source(data_source)
      {:ok, %DataSource{}}

      iex> delete_data_source(data_source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_data_source(%DataSource{} = data_source) do
    Repo.delete(data_source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking data_source changes.

  ## Examples

      iex> change_data_source(data_source)
      %Ecto.Changeset{data: %DataSource{}}

  """
  def change_data_source(%DataSource{} = data_source, attrs \\ %{}) do
    DataSource.changeset(data_source, attrs)
  end
end

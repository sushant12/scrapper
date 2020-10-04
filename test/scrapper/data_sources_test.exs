defmodule Scrapper.DataSourcesTest do
  use Scrapper.DataCase

  alias Scrapper.DataSources

  describe "data_source" do
    alias Scrapper.DataSources.DataSource

    @valid_attrs %{last_rub_at: "2010-04-17T14:00:00.000000Z", name: "some name"}
    @update_attrs %{last_rub_at: "2011-05-18T15:01:01.000000Z", name: "some updated name"}
    @invalid_attrs %{last_rub_at: nil, name: nil}

    def data_source_fixture(attrs \\ %{}) do
      {:ok, data_source} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DataSources.create_data_source()

      data_source
    end

    test "list_data_source/0 returns all data_source" do
      data_source = data_source_fixture()
      assert DataSources.list_data_source() == [data_source]
    end

    test "get_data_source!/1 returns the data_source with given id" do
      data_source = data_source_fixture()
      assert DataSources.get_data_source!(data_source.id) == data_source
    end

    test "create_data_source/1 with valid data creates a data_source" do
      assert {:ok, %DataSource{} = data_source} = DataSources.create_data_source(@valid_attrs)
      assert data_source.last_rub_at == DateTime.from_naive!(~N[2010-04-17T14:00:00.000000Z], "Etc/UTC")
      assert data_source.name == "some name"
    end

    test "create_data_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DataSources.create_data_source(@invalid_attrs)
    end

    test "update_data_source/2 with valid data updates the data_source" do
      data_source = data_source_fixture()
      assert {:ok, %DataSource{} = data_source} = DataSources.update_data_source(data_source, @update_attrs)
      assert data_source.last_rub_at == DateTime.from_naive!(~N[2011-05-18T15:01:01.000000Z], "Etc/UTC")
      assert data_source.name == "some updated name"
    end

    test "update_data_source/2 with invalid data returns error changeset" do
      data_source = data_source_fixture()
      assert {:error, %Ecto.Changeset{}} = DataSources.update_data_source(data_source, @invalid_attrs)
      assert data_source == DataSources.get_data_source!(data_source.id)
    end

    test "delete_data_source/1 deletes the data_source" do
      data_source = data_source_fixture()
      assert {:ok, %DataSource{}} = DataSources.delete_data_source(data_source)
      assert_raise Ecto.NoResultsError, fn -> DataSources.get_data_source!(data_source.id) end
    end

    test "change_data_source/1 returns a data_source changeset" do
      data_source = data_source_fixture()
      assert %Ecto.Changeset{} = DataSources.change_data_source(data_source)
    end
  end
end

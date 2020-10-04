defmodule Scrapper.PriceTest do
  use Scrapper.DataCase

  alias Scrapper.Price

  describe "price" do
    alias Scrapper.Price.Schema

    @valid_attrs %{price: 120.5}
    @update_attrs %{price: 456.7}
    @invalid_attrs %{price: nil}

    def schema_fixture(attrs \\ %{}) do
      {:ok, schema} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Price.create_schema()

      schema
    end

    test "list_price/0 returns all price" do
      schema = schema_fixture()
      assert Price.list_price() == [schema]
    end

    test "get_schema!/1 returns the schema with given id" do
      schema = schema_fixture()
      assert Price.get_schema!(schema.id) == schema
    end

    test "create_schema/1 with valid data creates a schema" do
      assert {:ok, %Schema{} = schema} = Price.create_schema(@valid_attrs)
      assert schema.price == 120.5
    end

    test "create_schema/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Price.create_schema(@invalid_attrs)
    end

    test "update_schema/2 with valid data updates the schema" do
      schema = schema_fixture()
      assert {:ok, %Schema{} = schema} = Price.update_schema(schema, @update_attrs)
      assert schema.price == 456.7
    end

    test "update_schema/2 with invalid data returns error changeset" do
      schema = schema_fixture()
      assert {:error, %Ecto.Changeset{}} = Price.update_schema(schema, @invalid_attrs)
      assert schema == Price.get_schema!(schema.id)
    end

    test "delete_schema/1 deletes the schema" do
      schema = schema_fixture()
      assert {:ok, %Schema{}} = Price.delete_schema(schema)
      assert_raise Ecto.NoResultsError, fn -> Price.get_schema!(schema.id) end
    end

    test "change_schema/1 returns a schema changeset" do
      schema = schema_fixture()
      assert %Ecto.Changeset{} = Price.change_schema(schema)
    end
  end
end

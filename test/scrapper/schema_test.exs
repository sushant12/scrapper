defmodule Scrapper.SchemaTest do
  use Scrapper.DataCase

  alias Scrapper.Schema

  describe "item" do
    alias Scrapper.Schema.Item

    @valid_attrs %{description: "some description", image: "some image", name: "some name"}
    @update_attrs %{description: "some updated description", image: "some updated image", name: "some updated name"}
    @invalid_attrs %{description: nil, image: nil, name: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schema.create_item()

      item
    end

    test "list_item/0 returns all item" do
      item = item_fixture()
      assert Schema.list_item() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Schema.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Schema.create_item(@valid_attrs)
      assert item.description == "some description"
      assert item.image == "some image"
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Schema.update_item(item, @update_attrs)
      assert item.description == "some updated description"
      assert item.image == "some updated image"
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_item(item, @invalid_attrs)
      assert item == Schema.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Schema.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Schema.change_item(item)
    end
  end
end

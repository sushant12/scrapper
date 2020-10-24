defmodule Scrapper.SastodealWorker do
  use Oban.Worker, queue: :sastodeal
  import Ecto.Query
  alias Scrapper.{Repo}
  alias Scrapper.Schema.{Items, Price}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"url" => url, "data_source_id" => data_source_id}}) do
    items =
      HTTPoison.get!(url)
      |> parse_item(data_source_id)

    Repo.insert_all(Items, items,
      on_conflict: {:replace, [:description, :image, :price]},
      conflict_target: [:name, :data_source_id]
    )

    saved_items =
      from(i in Items, where: i.data_source_id == ^data_source_id)
      |> Repo.all()

    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    prices =
      items
      |> Enum.map(fn item ->
        %{
          item_id: Enum.find(saved_items, fn x -> x.name == item[:name] end) |> Map.get(:id),
          price: item[:price],
          created_at: Date.utc_today(),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    Repo.insert_all(Price, prices,
      on_conflict: {:replace, [:price]},
      conflict_target: [:item_id, :created_at]
    )

    :ok
  end

  def parse_item(response, data_source_id) do
    {:ok, document} = Floki.parse_document(response.body)

    {"ol", [{"class", "products list items product-items"}], items} =
      document
      |> Floki.find("ol.products.list.items.product-items")
      |> List.first()

    items
    |> Enum.map(fn x ->
      name =
        x
        |> Floki.find("div.product.details.product-item-details")
        |> Floki.find("a.product-item-link")
        |> Floki.text()

      image =
        x
        |> Floki.find("img.product-image-photo")
        |> Floki.attribute("src")
        |> hd

      price =
        x
        |> Floki.find(".price")
        |> Floki.text()

      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

      %{
        name: name,
        image: image,
        price: price,
        data_source_id: data_source_id,
        inserted_at: timestamp,
        updated_at: timestamp
      }
    end)
  end
end

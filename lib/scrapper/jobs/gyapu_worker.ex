defmodule Scrapper.GyapuWorker do
  use Oban.Worker, queue: :gyapu
  import Ecto.Query
  alias Scrapper.{Gyapu, Repo}
  alias Scrapper.Schema.{Items, Price}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"url" => url, "data_source_id" => data_source_id}}) do
    total = total_items(url)
    resp = Gyapu.get_data("#{url}?size=#{total}")
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    items =
      resp["data"]
      |> Enum.map(fn item ->
        %{
          name: item["name"],
          description: item["description"],
          price: "#{item["min_sales_price"]}",
          data_source_id: data_source_id,
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    Repo.insert_all(Items, items,
      on_conflict: {:replace, [:description, :image, :price]},
      conflict_target: [:name, :data_source_id]
    )

    saved_items =
      from(i in Items, where: i.data_source_id == ^data_source_id)
      |> Repo.all()

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

  defp total_items(url) do
    resp = Gyapu.get_data(url)
    resp["totaldata"]
  end
end

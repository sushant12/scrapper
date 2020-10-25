defmodule Scrapper.SastodealWorker do
  use Oban.Worker, queue: :sastodeal
  import Ecto.Query
  alias Scrapper.{Repo}
  alias Scrapper.Schema.{Items, Price}

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{"type" => "single", "url" => url, "data_source_id" => data_source_id}
      }) do
    items =
      HTTPoison.get!(url)
      |> extract_html
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

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "type" => "params",
          "url" => url,
          "params" => params,
          "data_source_id" => data_source_id
        }
      }) do
    html =
      HTTPoison.get!(url <> params)
      |> valid_json_response

    case html do
      :discard ->
        :discard

      _ ->
        2..String.to_integer(get_total_pages(html))
        |> Enum.each(fn x ->
          %{type: "single", url: "#{url}?is_scroll=1&p=#{x}", data_source_id: data_source_id}
          |> Scrapper.SastodealWorker.new()
          |> Oban.insert()
        end)

        :ok
    end
  end

  defp parse_item(html, data_source_id) do
    {:ok, document} = Floki.parse_document(html)

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

  defp parse_html_fragment(html_fragment) do
    Floki.parse_fragment!(html_fragment)
    |> List.first()
  end

  defp get_total_pages(html_fragment) do
    parse_html_fragment(html_fragment) |> Floki.find("div#am-page-count") |> Floki.text()
  end

  defp valid_json_response(response) do
    case response.body |> Jason.decode() do
      {:ok, %{"categoryProducts" => html_fragment}} ->
        html_fragment

      _ ->
        :discard
    end
  end

  defp extract_html(response) do
    case valid_json_response(response) do
      :discard ->
        response.body

      html_fragment ->
        html_fragment
    end
  end
end

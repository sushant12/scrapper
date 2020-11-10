defmodule Scrapper.DarazWorker do
  use Oban.Worker, queue: :daraz

  import Ecto.Query
  alias Scrapper.{Repo}
  alias Scrapper.Schema.{Items, Price}

  @impl Worker
  def backoff(_) do
    120
  end

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{"type" => "single", "url" => url, "data_source_id" => data_source_id}
      }) do
    document =
      HTTPoison.get!(url, [], follow_redirect: true) |> Map.get(:body) |> Floki.parse_document!()

    scripts = document |> Floki.find("head") |> Floki.find("script")

    items =
      scripts
      |> Enum.find(fn {_, _, body} -> body |> hd |> String.match?(~r/window\.pageData=\{/) end)
      |> extract_body
      |> build_data(data_source_id)

    save_data(items)

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

    total_pages =
      scripts
      |> Enum.find(fn {_, _, body} -> body |> hd |> String.match?(~r/window\.pageData=\{/) end)
      |> get_total_pages()

    2..total_pages
    |> Enum.each(fn i ->
      # %{type: "multiple", url: "#{url}?page=#{i}", data_source_id: data_source_id}
      # |> Scrapper.DarazWorker.new()
      # |> Oban.insert()
      IO.inspect("#{url}?page=#{i}")

      document =
        HTTPoison.get!("#{url}?page=#{i}", [], follow_redirect: true)
        |> Map.get(:body)
        |> Floki.parse_document!()

      scripts = document |> Floki.find("head") |> Floki.find("script")

      items =
        scripts
        |> Enum.find(fn {_, _, body} -> body |> hd |> String.match?(~r/window\.pageData=\{/) end)
        |> extract_body
        |> build_data(data_source_id)

      save_data(items)

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
    end)

    :ok
  end

  def perform(%Oban.Job{
        args: %{"type" => "multiple", "url" => url, "data_source_id" => data_source_id}
      }) do
    document =
      HTTPoison.get!(url, [], follow_redirect: true) |> Map.get(:body) |> Floki.parse_document!()

    scripts = document |> Floki.find("head") |> Floki.find("script")

    items =
      scripts
      |> Enum.find(fn {_, _, body} -> body |> hd |> String.match?(~r/window\.pageData=\{/) end)
      |> extract_body
      |> build_data(data_source_id)

    save_data(items)

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

  defp extract_body({_, _, body}) do
    body
    |> hd()
    |> String.replace("window.pageData=", "")
    |> Jason.decode!()
  end

  defp build_data(script, data_source_id) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    script
    |> Map.get("mods")
    |> Map.get("listItems")
    |> Enum.map(
      &%{
        name: &1["name"],
        image: &1["image"],
        price: &1["price"],
        data_source_id: data_source_id,
        inserted_at: timestamp,
        updated_at: timestamp
      }
    )
    |> Enum.uniq_by(fn x -> x.name end)
  end

  defp save_data(items) do
    Repo.insert_all(Items, items,
      on_conflict: {:replace, [:description, :image, :price]},
      conflict_target: [:name, :data_source_id]
    )
  end

  defp get_total_pages(script) do
    body =
      script
      |> extract_body()

    {total_results, _} =
      body
      |> Map.get("mainInfo")
      |> Map.get("totalResults")
      |> Float.parse()

    {page_size, _} =
      body
      |> Map.get("mainInfo")
      |> Map.get("pageSize")
      |> Float.parse()

    Float.ceil(total_results / page_size) |> trunc
  end
end

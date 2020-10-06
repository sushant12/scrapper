defmodule Scrapper.GyapuWorker do
  use Oban.Worker, queue: :gyapu

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"url" => url}}) do
    total = total_items(url)

    resp = Scrapper.Gyapu.get_data("#{url}?size=#{total}")

    resp["data"]
    |> Enum.map(fn item ->
      %{
        name: item["name"],
        description: item["description"],
        price: item["min_sales_price"]
      }
    end)

    :ok
  end

  defp total_items(url) do
    resp = Scrapper.Gyapu.get_data(url)
    resp["totaldata"]
  end
end

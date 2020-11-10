defmodule ScrapperWeb.HomeController do
  use ScrapperWeb, :controller
  alias Scrapper.Query.DataSource

  def index(conn, _params) do
    data_sources = DataSource.list_data_sources()

    render(conn, "index.html", data_sources: data_sources)
  end

  def scrape(conn, %{"data_source" => "daraz.com"}) do
    data_source = DataSource.get_data_source("daraz.com")

    [
      "https://www.daraz.com.np/mobiles-tablets-accessories",
      "https://www.daraz.com.np/mens-clothing"
    ]
    |> Enum.each(fn url ->
      %{type: "single", url: url, data_source_id: data_source.id}
      |> Scrapper.DarazWorker.new()
      |> Oban.insert()
    end)

    conn
    |> put_flash(:info, "Started!")
    |> redirect(to: Routes.home_path(conn, :index))
  end

  def scrape(conn, %{"data_source" => "gyapu.com"}) do
    data_source = DataSource.get_data_source("gyapu.com")

    ["/dashain-dhamaka", "/civil-mall"]
    |> Enum.each(fn url ->
      %{url: url, data_source_id: data_source.id}
      |> Scrapper.GyapuWorker.new()
      |> Oban.insert()
    end)

    conn
    |> put_flash(:info, "Started!")
    |> redirect(to: Routes.home_path(conn, :index))
  end

  def scrape(conn, %{"data_source" => "sastodeal.com"}) do
    data_source = DataSource.get_data_source("sastodeal.com")

    urls = [
      "https://www.sastodeal.com/electronic/televisions/mi.html",
      "https://www.sastodeal.com/sd-fast/sd-liquors.html",
      "https://www.sastodeal.com/sd-fast/frozen-food.html",
      "https://www.sastodeal.com/sd-fast/food-essentials.html"
    ]

    urls
    |> Enum.each(fn url ->
      %{type: "single", url: url, data_source_id: data_source.id}
      |> Scrapper.SastodealWorker.new()
      |> Oban.insert()
    end)

    urls
    |> Enum.each(fn url ->
      %{type: "params", url: url, params: "?is_scroll=1&p=2", data_source_id: data_source.id}
      |> Scrapper.SastodealWorker.new()
      |> Oban.insert()
    end)

    conn
    |> put_flash(:info, "Started!")
    |> redirect(to: Routes.home_path(conn, :index))
  end
end

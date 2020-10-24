defmodule ScrapperWeb.HomeController do
  use ScrapperWeb, :controller
  alias Scrapper.Query.DataSource

  def index(conn, _params) do
    data_sources = DataSource.list_data_sources()

    render(conn, "index.html", data_sources: data_sources)
  end

  def scrape(conn, %{"data_source" => "gyapu.com"}) do
    data_source = DataSource.get_data_source("gyapu.com")

    ["/dashain-dhamaka", "/civil-mall"]
    |> Enum.map(fn url ->
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

    [
      "https://www.sastodeal.com/electronic/televisions/mi.html",
      "https://www.sastodeal.com/sd-fast/sd-liquors.html"
    ]
    |> Enum.map(fn url ->
      %{url: url, data_source_id: data_source.id}
      |> Scrapper.SastodealWorker.new()
      |> Oban.insert()
    end)

    conn
    |> put_flash(:info, "Started!")
    |> redirect(to: Routes.home_path(conn, :index))
  end
end

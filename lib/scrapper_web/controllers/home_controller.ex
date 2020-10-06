defmodule ScrapperWeb.HomeController do
  use ScrapperWeb, :controller
  alias Scrapper.DataSources

  def index(conn, _params) do
    data_sources = DataSources.list_data_source()
    render(conn, "index.html", data_sources: data_sources)
  end

  def scrape(_conn, %{"data_source" => "gyapu"}) do
    ["/dashain-dhamaka", "/civil-mall"]
    |> Enum.map(fn url ->
      %{url: url}
      |> Scrapper.GyapuWorker.new()
      |> Oban.insert()
    end)
  end
end

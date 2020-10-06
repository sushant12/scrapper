defmodule Scrapper.Gyapu do
  use Tesla

  plug Tesla.Middleware.BaseUrl,
       "https://www.gyapu.com/api/product/productbycategory"

  plug Tesla.Middleware.JSON

  def get_data(url) do
    {:ok, %Tesla.Env{body: body}} = get(url)
    body
  end
end

defmodule Scrapper.Repo do
  use Ecto.Repo,
    otp_app: :scrapper,
    adapter: Ecto.Adapters.Postgres
end

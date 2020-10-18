# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :scrapper,
  ecto_repos: [Scrapper.Repo]

# Configures the endpoint
config :scrapper, ScrapperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kijyyxsuf/8MQcrOmavEcvaYuPtEygvM2enwCKcKoptZ1dZyru66PygQRwiouZos",
  render_errors: [view: ScrapperWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Scrapper.PubSub,
  live_view: [signing_salt: "5pEksLxC"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :scrapper, Oban,
  repo: Scrapper.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [gyapu: 40, sastodeal: 40, daraz: 40, infi: 40, smartdoko: 40]

config :oban_ui, repo: Scrapper.Repo, app_name: ScrapperWeb
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

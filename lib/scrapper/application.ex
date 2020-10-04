defmodule Scrapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Scrapper.Repo,
      # Start the Telemetry supervisor
      ScrapperWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Scrapper.PubSub},
      # Start the Endpoint (http/https)
      ScrapperWeb.Endpoint
      # Start a worker by calling: Scrapper.Worker.start_link(arg)
      # {Scrapper.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scrapper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ScrapperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

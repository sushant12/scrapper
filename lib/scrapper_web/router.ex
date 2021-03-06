defmodule ScrapperWeb.Router do
  use ScrapperWeb, :router
  import ObanUi.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ScrapperWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScrapperWeb do
    pipe_through :browser
    oban_web("/oban")
    live "/", PageLive, :index
    resources "/home", HomeController, only: [:index]
    get "/scrape", HomeController, :scrape
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScrapperWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ScrapperWeb.Telemetry
    end
  end
end

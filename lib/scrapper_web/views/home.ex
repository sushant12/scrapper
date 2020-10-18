defmodule ScrapperWeb.HomeView do
  use ScrapperWeb, :view
  import Scrapper.Helpers.Job, only: [total_running_jobs: 1]
end

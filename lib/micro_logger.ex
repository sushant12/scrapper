defmodule MicroLogger do
  require Logger
  alias Scrapper.Query.DataSource
  alias Scrapper.Helpers.Job

  def handle_event([:oban, :job, :stop], _, meta, nil) do
    empty_queue? = Oban.check_queue(queue: meta.queue) |> Map.get(:running) |> Enum.count() == 0

    if empty_queue? do
      Job.get_data_source_name_from_queue(meta.queue)
      |> DataSource.get_data_source()
      |> DataSource.update_data_source(%{last_run_at: Date.utc_today()})
    end
  end
end

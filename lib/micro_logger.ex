defmodule MicroLogger do
  require Logger
  alias Scrapper.Query.DataSource
  alias Scrapper.Helpers.Job

  def handle_event([:oban, :job, :stop], _, meta, nil) do
    running_jobs = Oban.check_queue(queue: meta.queue) |> Map.get(:running)

    if running_jobs |> Enum.count() == 1 do
      job_id = running_jobs |> hd
      job = Oban.Job |> Scrapper.Repo.get(job_id)

      if job.state == "completed", do: update_last_run_at(meta.queue)
    end
  end

  defp update_last_run_at(queue) do
    Job.get_data_source_name_from_queue(queue)
    |> DataSource.get_data_source()
    |> DataSource.update_data_source(%{last_run_at: Date.utc_today()})
  end
end

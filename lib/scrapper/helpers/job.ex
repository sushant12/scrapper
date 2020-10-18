defmodule Scrapper.Helpers.Job do
  def total_running_jobs("gyapu.com") do
    Oban.check_queue(queue: :gyapu)
    |> check_running_jobs()
  end

  def total_running_jobs("infi.store") do
    Oban.check_queue(queue: :infi)
    |> check_running_jobs()
  end

  def total_running_jobs("daraaz.com") do
    Oban.check_queue(queue: :daraz)
    |> check_running_jobs()
  end

  def total_running_jobs("smartdoko.com") do
    Oban.check_queue(queue: :smartdoko)
    |> check_running_jobs()
  end

  def total_running_jobs("sastodeal.com") do
    Oban.check_queue(queue: :sastodeal)
    |> check_running_jobs()
  end

  def get_data_source_name_from_queue(name) do
    case name do
      "gyapu" ->
        "gyapu.com"

      "sastodeal" ->
        "sastodeal.com"

      "infistore" ->
        "infi.store"

      "daraz" ->
        "daraz.com"

      "smartdoko" ->
        "smartdoko.com"
    end
  end

  defp check_running_jobs(oban) do
    oban
    |> Map.get(:running)
    |> Enum.count()
  end
end

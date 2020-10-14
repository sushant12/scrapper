defmodule MicroLogger do
  require Logger

  def handle_event([:oban, :job, :start], _, meta, nil) do
    Logger.warn(meta)
  end
end

defmodule Mix.Tasks.WandCore.Version do
  use Mix.Task
  @version Mix.Project.config() |> Keyword.get(:version, "unknown")

  @moduledoc """
  Task to get the version of the WandCore archive.
  """
  @spec run([]) :: :ok
  def run(_args) do
    IO.puts(@version)
  end
end

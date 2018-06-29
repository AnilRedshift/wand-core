defmodule Mix.Tasks.WandCore.GetDeps do
  use Mix.Task
  @project WandCore.Interfaces.Project.impl()

  def run(_args) do
    @project.config()
    |> Keyword.get(:deps, [])
    |> WandCore.Poison.encode!()
    |> IO.puts
  end
end

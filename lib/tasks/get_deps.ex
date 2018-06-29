defmodule Mix.Tasks.Wand.GetDeps do
  use Mix.Task
  @project Wand.Interfaces.Project.impl()

  def run(args) do
    @project.config()
    |> Keyword.get(:deps, [])
    |> Wand.Poison.encode!()
    |> IO.puts
  end
end

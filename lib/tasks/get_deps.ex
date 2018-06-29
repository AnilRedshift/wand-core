defmodule Mix.Tasks.Wand.GetDeps do
  use Mix.Task

  def run(args) do
    Mix.Project.config()
    |> Keyword.get(:deps, [])
    |> Wand.Poison.encode!()
    |> IO.puts
  end
end

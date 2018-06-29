defmodule Mix.Tasks.WandCore.GetDeps do
  use Mix.Task
  alias WandCore.Opts
  @project WandCore.Interfaces.Project.impl()

  def run(_args) do
    @project.config()
    |> Keyword.get(:deps, [])
    |> encode_opts()
    |> WandCore.Poison.encode!()
    |> IO.puts()
  end

  defp encode_opts(dependencies) do
    Enum.map(dependencies, fn
      {name, requirement, opts} ->
        {name, requirement, Opts.encode(opts)}

      {name, opts} when is_list(opts) ->
        {name, Opts.encode(opts)}

      dependency ->
        dependency
    end)
  end
end

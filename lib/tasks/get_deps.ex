defmodule Mix.Tasks.WandCore.GetDeps do
  use Mix.Task
  alias WandCore.Opts
  @project WandCore.Interfaces.Project.impl()

  @moduledoc """
  Load an existing projects dependencies, and print it to the console in JSON format

  This task is used internally by wand init to gather the existing dependencies, in order to convert them into a WandFile.

  Specifically note that the JSON format here is just a JSON version of Application.deps(). It is _not_ WandFile format.

  See `WandCore.Opts` for the custom opts JSON
  """

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

defmodule Mix.Tasks.WandCore.Deps do
  use Mix.Task
  alias WandCore.Opts
  alias WandCore.WandFile
  alias WandCore.WandFile.Dependency

  @moduledoc """
  Task to load a wand.json file, and return Application deps format.
  This is used inside a mix.exs to allow wand to work for your project.

  Your mix.exs file should look something like this:
  <pre>
  def project do
    [
      app: :my_project,
      deps: Mix.Tasks.WandCore.Deps.run([])
      ...
    ]
  end
  </pre>
  """

  @type name :: atom()
  @type version :: String.t()
  @type opts :: keyword()

  @type dependency :: {name, version} | {name, opts} | {name, version, opts}
  @spec run([]) :: [dependency]
  def run(_args) do
    {:ok, file} = WandFile.load()
    Enum.map(file.dependencies, &convert_dependency/1)
  end

  defp convert_dependency(%Dependency{name: name, requirement: requirement, opts: opts})
       when opts == %{} do
    {convert_name(name), requirement}
  end

  defp convert_dependency(%Dependency{name: name, requirement: requirement, opts: opts})
       when requirement == nil do
    {convert_name(name), convert_opts(opts)}
  end

  defp convert_dependency(%Dependency{name: name, requirement: requirement, opts: opts}) do
    {convert_name(name), requirement, convert_opts(opts)}
  end

  defp convert_name(name), do: String.to_atom(name)

  defp convert_opts(opts) do
    Opts.decode(opts)
    |> Enum.into([])
  end
end

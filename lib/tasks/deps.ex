defmodule Mix.Tasks.WandCore.Deps do
  use Mix.Task
  alias WandCore.Opts
  alias WandCore.WandFile
  alias WandCore.WandFile.Dependency

  def run(_args) do
    {:ok, file} = WandFile.load()
    Enum.map(file.dependencies, &convert_dependency/1)
  end

  defp convert_dependency(%Dependency{name: name, requirement: requirement, opts: opts})
       when opts == %{} do
    {String.to_atom(name), requirement}
  end

  defp convert_dependency(%Dependency{} = dependency) do
    name = String.to_atom(dependency.name)
    requirement = dependency.requirement

    opts =
      Opts.decode(dependency.opts)
      |> Enum.into([])

    {name, requirement, opts}
  end
end

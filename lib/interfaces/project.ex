defmodule WandCore.Interfaces.Project do
  @callback config() :: keyword()

  def impl(), do: Application.get_env(:wand_core, :project, Mix.Project)
end

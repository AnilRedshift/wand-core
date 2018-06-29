defmodule WandCore.Interfaces.Project do
  @moduledoc false
  @callback config() :: keyword()

  def impl(), do: Application.get_env(:wand_core, :project, Mix.Project)
end

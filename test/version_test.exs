defmodule VersionTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "get the version" do
    assert capture_io(fn -> Mix.Tasks.WandCore.Version.run([]) end) == get_version() <> "\n"
  end

  defp get_version() do
    Mix.Project.config()
    |> Keyword.fetch!(:version)
  end
end

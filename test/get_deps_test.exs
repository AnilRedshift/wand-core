defmodule GetDepsTest do
  use ExUnit.Case, async: true
  import Mox
  import ExUnit.CaptureIO

  setup :verify_on_exit!

  test "prints config" do
    [
      {:mox, "~> 0.3.2", [only: :test]},
      {:ex_doc, ">= 0.0.0", [only: :dev]}
    ]
    |> stub_project()

    [
      ["mox", "~> 0.3.2", [["only", ":test"]]],
      ["ex_doc", ">= 0.0.0", [["only", ":dev"]]]
    ]
    |> validate()
  end

  test "gets a dependency with only two keys" do
    [
      {:mox, "~> 0.3.2"}
    ]
    |> stub_project()

    [
      ["mox", "~> 0.3.2"]
    ]
    |> validate()
  end

  defp stub_project(deps) do
    config = [deps: deps]
    expect(WandCore.ProjectMock, :config, fn -> config end)
  end

  defp validate(expected) do
    result = capture_io(fn -> Mix.Tasks.WandCore.GetDeps.run([]) end) |> WandCore.Poison.decode!()
    assert result == expected
  end
end

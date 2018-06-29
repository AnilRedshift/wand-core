defmodule DepsTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.WandCore.Deps
  alias WandCore.WandFile
  alias WandCore.WandFile.Dependency

  import Mox

  setup :verify_on_exit!

  test "returns an empty array if the dependencies are empty" do
    stub_read(%WandFile{})
    assert Deps.run([]) == []
  end

  test "Converts a simple dependency" do
    %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: "~>3.1.2"}
      ]
    }
    |> stub_read()
    assert Deps.run([]) == [
      {:poison, "~>3.1.2"},
    ]
  end

  test "converts a dependency with opts" do
    %WandFile{
      dependencies: [
        %Dependency{
          name: "poison",
          requirement: "~>3.1.2",
          opts: %{
            only: :test
          }
        }
      ]
    }
    |> stub_read()
    assert Deps.run([]) == [
      {:poison, "~>3.1.2", only: :test},
    ]
  end

  defp stub_read(file) do
    contents = WandCore.Poison.encode!(file)
      expect(WandCore.FileMock, :read, fn "wand.json" -> {:ok, contents} end)
  end
end

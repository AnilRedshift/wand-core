defmodule WandEncoderTest do
  use ExUnit.Case, async: true
  alias WandCore.WandFile
  alias WandCore.WandFile.Dependency
  alias WandCore.Poison

  test "Encode an empty WandFile" do
    assert encode(%WandFile{}) == "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {}\n}"
  end

  test "Encode a simple dependency" do
    file = %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: ">= 0.0.0"}
      ]
    }
    assert encode(file) == "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": \">= 0.0.0\"\n  }\n}"
  end

  test "Encode a dependency with an atom as a opt value" do
    file = %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: ">= 0.0.0", opts: %{only: :test}}
      ]
    }
    assert encode(file) == "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": [\n      \">= 0.0.0\",\n      {\n        \"only\": \":test\"\n      }\n    ]\n  }\n}"
  end

  test "Encode a dependency with a boolean as an opt value" do
    file = %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: ">= 0.0.0", opts: %{optional: true}}
      ]
    }
    assert encode(file) == "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": [\n      \">= 0.0.0\",\n      {\n        \"optional\": \":true\"\n      }\n    ]\n  }\n}"
  end

  test "Encode a dependency with a list of atoms as a opt value" do
    file = %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: ">= 0.0.0", opts: %{only: [:test, :dev]}}
      ]
    }
    assert encode(file) == "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": [\n      \">= 0.0.0\",\n      {\n        \"only\": [\n          \":test\",\n          \":dev\"\n        ]\n      }\n    ]\n  }\n}"
  end

  defp encode(file), do: Poison.encode!(file, pretty: true)
end

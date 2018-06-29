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

    assert encode(file) ==
             "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": \">= 0.0.0\"\n  }\n}"
  end

  test "Encode a dependency with an atom as a opt value" do
    file = %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: ">= 0.0.0", opts: %{only: :test}}
      ]
    }

    assert encode(file) ==
             "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": [\">= 0.0.0\",{\"only\":\":test\"}]\n  }\n}"
  end

  test "Encode a dependency with a boolean as an opt value" do
    file = %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: ">= 0.0.0", opts: %{optional: true}}
      ]
    }

    assert encode(file) ==
             "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": [\">= 0.0.0\",{\"optional\":\":true\"}]\n  }\n}"
  end

  test "Encode a dependency with a list of atoms as a opt value" do
    file = %WandFile{
      dependencies: [
        %Dependency{name: "poison", requirement: ">= 0.0.0", opts: %{only: [:test, :dev]}}
      ]
    }

    assert encode(file) ==
             "{\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"poison\": [\">= 0.0.0\",{\"only\":[\":test\",\":dev\"]}]\n  }\n}"
  end

  defp encode(file), do: Poison.encode!(file, pretty: true)
end

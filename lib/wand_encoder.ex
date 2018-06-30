defmodule Wand.WandEncoder do
  alias WandCore.WandFile
  alias WandCore.WandFile.Dependency
  alias WandCore.Poison.Encoder

  @moduledoc """
  A [Poison](https://github.com/devinus/poison#encoder) encoder for `WandCore.WandFile`

  It differs from the normal JSON encoding of a struct in the following ways:

  1. The dependencies map is sorted by key name
  2. Options are inlined and not pretty-printed, even though the rest of the object is
  3. Atoms in a `WandCore.WandFile.Dependency` are encoded as `:atom_name`
  """

  defimpl WandCore.Poison.Encoder, for: WandFile do
    @default_indent 2
    @default_offset 0

    def encode(%WandFile{version: version, dependencies: dependencies}, options) do
      indent = indent(options)
      offset = offset(options) + indent
      options = offset(options, offset)

      [
        {"version", version},
        {"dependencies", dependencies}
      ]
      |> Enum.map(fn {key, value} ->
        {parse(key, options), parse(value, options)}
      end)
      |> create_map_body(offset)
      |> wrap_map(offset, indent)
    end

    defp parse([], _options), do: "{}"

    defp parse(dependencies, options) when is_list(dependencies) do
      indent = indent(options)
      offset = offset(options) + indent
      options = offset(options, offset)

      dependencies =
        Enum.sort_by(dependencies, & &1.name)
        |> Enum.map(fn dependency ->
          {parse(dependency.name, options), parse(dependency, options)}
        end)

      create_map_body(dependencies, offset)
      |> wrap_map(offset, indent)
    end

    defp parse(%Dependency{requirement: requirement, opts: opts}, options) when opts == %{} do
      Encoder.BitString.encode(requirement, options)
    end

    defp parse(%Dependency{requirement: nil, opts: opts}, options) do
      options = Keyword.drop(options, [:pretty])

      [WandCore.Opts.encode(opts)]
      |> Encoder.List.encode(options)
    end

    defp parse(%Dependency{requirement: requirement, opts: opts}, options) do
      options = Keyword.drop(options, [:pretty])

      [requirement, WandCore.Opts.encode(opts)]
      |> Encoder.List.encode(options)
    end

    defp parse(key, options) when is_binary(key) do
      to_string(key)
      |> Encoder.BitString.encode(options)
    end

    defp wrap_map(body, offset, indent) do
      ["{\n", body, ?\n, spaces(offset - indent), ?}]
    end

    defp create_map_body(enumerable, offset) do
      Enum.reverse(enumerable)
      |> Enum.reduce([], fn {key, value}, acc ->
        [
          ",\n",
          spaces(offset),
          key,
          ": ",
          value
          | acc
        ]
      end)
      |> tl
    end

    defp indent(options) do
      Keyword.get(options, :indent, @default_indent)
    end

    defp offset(options) do
      Keyword.get(options, :offset, @default_offset)
    end

    defp offset(options, value) do
      Keyword.put(options, :offset, value)
    end

    defp spaces(count) do
      :binary.copy(" ", count)
    end
  end
end

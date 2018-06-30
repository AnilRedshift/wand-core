defmodule WandCore.Opts do
  @type t :: map() | list()
  @moduledoc """
  Helper module for manipulating opts of a `WandCore.WandFile.Dependency`

  This is used in conjunction with the JSON encoder to ensure that atoms are properly encoded/decoded
  """

  @doc """
  Encodes a map or list of options by changing atom values into `":atom_name"`
  """
  @spec encode(t) :: t
  def encode(opts), do: convert_opts(opts, :encode)

  @doc """
  Decodes a map or list of options by changing string values from `":name"` to `"name"`
  """
  @spec decode(t) :: t
  def decode(opts), do: convert_opts(opts, :decode)

  defp convert_opts(%{} = opts, mode) do
    Enum.map(opts, &convert_tuple(&1, mode))
    |> Enum.into(%{})
  end

  defp convert_opts(opts, mode) when is_list(opts) do
    Enum.map(opts, fn
      {key, value} when is_atom(key) -> convert_tuple({key, value}, mode)
      value -> convert_tuple({:dummy, value}, mode) |> elem(1)
    end)
  end

  defp convert_tuple({key, value}, mode) do
    case {key, value} do
      {key, value} when is_atom(value) and mode == :encode -> {key, encode_atom(value)}
      {key, ":" <> value} when mode == :decode -> {key, decode_atom(value)}
      {key, value} when is_list(value) -> {key, convert_opts(value, mode)}
      {key, value} when is_map(value) -> {key, convert_opts(value, mode)}
      {key, value} -> {key, value}
    end
  end

  defp encode_atom(value), do: ":#{value}"
  defp decode_atom(value), do: String.to_atom(value)
end

defmodule WandCore.Opts do
  def encode(opts), do: convert_opts(opts, :encode)
  def decode(opts), do: convert_opts(opts, :decode)

  defp convert_opts(%{} = opts, mode) do
    Enum.map(opts, fn
      {key, value} when is_atom(value) and mode == :encode -> {key, encode_atom(value)}
      {key, ":" <> value} when mode == :decode -> {key, decode_atom(value)}
      {key, value} when is_list(value) -> {key, convert_opts(value, mode)}
      {key, value} when is_map(value) -> {key, convert_opts(value, mode)}
      {key, value} -> {key, value}
    end)
    |> Enum.into(%{})
  end

  defp convert_opts([{key, value} | tail], :encode) when is_atom(value) do
    [{key, encode_atom(value)} | convert_opts(tail, :encode)]
  end

  defp convert_opts([{key, ":" <> value} | tail], :decode) do
    [{key, decode_atom(value)} | convert_opts(tail, :decode)]
  end

  defp convert_opts(opts, mode) when is_list(opts) do
    Enum.with_index(opts)
    |> Enum.into(%{}, fn {k, v} -> {v, k} end)
    |> convert_opts(mode)
    |> Map.values()
  end

  defp encode_atom(value), do: ":#{value}"
  defp decode_atom(value), do: String.to_atom(value)
end

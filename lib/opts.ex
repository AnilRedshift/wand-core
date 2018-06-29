defmodule WandCore.Opts do
  def encode(opts), do: convert_opts(opts, :encode)
  def decode(opts), do: convert_opts(opts, :decode)

  def convert_opts(%{}=opts, mode) do
    Enum.map(opts, fn
      {key, value} when is_atom(value) and mode == :encode -> {key, ":#{value}"}
      {key, ":" <> value} when mode == :decode -> {key, value}
      {key, value} when is_list(value) -> {key, convert_opts(value, mode)}
      {key, value} when is_map(value) -> {key, convert_opts(value, mode)}
      {key, value} -> {key, value}
    end)
    |> Enum.into(%{})
  end

  def convert_opts(opts, mode) when is_list(opts) do
    Enum.with_index(opts)
    |> Enum.into(%{}, fn {k,v} -> {v,k} end)
    |> convert_opts(mode)
    |> Map.values()
  end
end

defmodule WandCore.TupleEncoder do
  @moduledoc false
  alias WandCore.Poison.Encoder

  defimpl Encoder, for: Tuple do
    def encode(data, options) when is_tuple(data) do
      data
      |> Tuple.to_list
      |> Encoder.List.encode(options)
    end
  end
end

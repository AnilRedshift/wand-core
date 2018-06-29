defmodule Wand.PoisonTest do
  use ExUnit.Case, async: true

  test "encode/decode round trip" do
    data = %{hello: "world"}
    assert data = data
    |> Wand.Poison.encode!()
    |> Wand.Poison.decode!()
  end
end

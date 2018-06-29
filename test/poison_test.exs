defmodule WandCore.PoisonTest do
  use ExUnit.Case, async: true

  test "encode/decode round trip" do
    data = %{"hello" => "world"}
    assert data == data
    |> Wand.Poison.encode!()
    |> Wand.Poison.decode!()
  end

  test "encodes tuples" do
    assert Wand.Poison.encode!({:hello, :world}) == "[\"hello\",\"world\"]"
  end
end

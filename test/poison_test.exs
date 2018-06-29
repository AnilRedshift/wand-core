defmodule WandCore.PoisonTest do
  use ExUnit.Case, async: true

  test "encode/decode round trip" do
    data = %{"hello" => "world"}

    assert data ==
             data
             |> WandCore.Poison.encode!()
             |> WandCore.Poison.decode!()
  end

  test "encodes tuples" do
    assert WandCore.Poison.encode!({:hello, :world}) == "[\"hello\",\"world\"]"
  end
end

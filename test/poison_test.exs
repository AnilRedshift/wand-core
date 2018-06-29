defmodule PoisonTest do
  use ExUnit.Case, async: true
  
  test "encode/decode round trip" do
    data = %{hello: "world"}
    assert data = data
    |> Poison.encode!()
    |> Poison.decode!()
  end
end

defmodule OptsTest do
  use ExUnit.Case, async: true
  alias WandCore.Opts

  test "encodes an atom" do
    assert Opts.encode(%{a: :b}) == %{a: ":b"}
  end

  test "decodes an atom" do
    assert Opts.decode(%{a: ":b"}) == %{a: :b}
  end

  test "encodes a string" do
    assert Opts.encode(%{a: "not:atom"}) == %{a: "not:atom"}
  end

  test "decodes a string" do
    assert Opts.decode(%{a: "not:atom"}) == %{a: "not:atom"}
  end
end
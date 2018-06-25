defmodule WandCoreTest do
  use ExUnit.Case
  doctest WandCore

  test "greets the world" do
    assert WandCore.hello() == :world
  end
end

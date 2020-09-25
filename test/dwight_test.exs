defmodule DwightTest do
  use ExUnit.Case
  doctest Dwight

  test "greets the world" do
    assert Dwight.hello() == :world
  end
end

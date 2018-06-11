defmodule UpclidTest do
  use ExUnit.Case
  doctest Upclid

  test "gets updates" do
    assert Upclid.updates() == :world
  end
end

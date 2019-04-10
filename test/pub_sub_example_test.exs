defmodule PubSubExampleTest do
  use ExUnit.Case
  doctest PubSubExample

  test "greets the world" do
    assert PubSubExample.hello() == :world
  end
end

defmodule MyRabbitTest do
  use ExUnit.Case
  doctest MyRabbit

  test "greets the world" do
    assert MyRabbit.hello() == :world
  end
end

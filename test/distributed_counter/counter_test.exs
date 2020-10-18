defmodule CounterTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = GenServer.start_link(DistributedCounter, %{})
    {:ok, counter: pid}
  end

  test "initial state is empty", %{counter: counter} do
    assert get(counter) == %{}
  end

  test "increment and check counter", %{counter: counter} do
    assert get(counter) == %{}
    assert :ok == increment(counter, 0, ["a", "b"])
    assert :ok == increment(counter, 25, ["a", "c"])
    assert :ok == increment(counter, 3, ["c", "e"])
    assert get(counter) == %{a: 25, b: 0, c: 28, e: 3}
  end

  def get(counter) do
    GenServer.call(counter, :get)
  end

  def increment(counter, count, labels) do
    GenServer.cast(counter, {:increment, {count, labels}})
  end
end

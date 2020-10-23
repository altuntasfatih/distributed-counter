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

  test "format query expressions" do
    assert DistributedCounter.convert_labels("a,b,c") == [:a, :b, :c]
  end

  test "increment and query expression", %{counter: counter} do
    assert get(counter) == %{}
    assert :ok == increment(counter, 0, ["a", "b"])
    assert :ok == increment(counter, 25, ["a", "c"])
    assert :ok == increment(counter, 3, ["c", "e"])
    assert query(counter, "a,b,c,d") == {:ok, [a: 25, b: 0, c: 28]}
  end

  test "query expression return not found", %{counter: counter} do
    assert get(counter) == %{}
    assert :ok == increment(counter, 25, ["x", "z"])
    assert query(counter, "a,b,c") ==  {:error, "not found"}
  end

  def get(counter) do
    GenServer.call(counter, :get)
  end

  def query(counter, expression) do
    GenServer.call(counter, {:query, DistributedCounter.convert_labels(expression)})
  end

  def increment(counter, count, labels) do
    GenServer.cast(counter, {:increment, {count, labels}})
  end
end

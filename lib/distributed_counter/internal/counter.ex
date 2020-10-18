defmodule DistributedCounter do
  use GenServer
  require Logger

  def start_link(state) do
    Logger.info("Counter is starting")
    GenServer.start_link(__MODULE__, state, name: via_tuple(:counter))
  end

  @impl true
  def init(labels = %{}) do
    {:ok, labels}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:increment, {count, labels}}, _from, state) do
    new_state =
      labels
      |> Enum.reduce(state, fn label, acc ->
        Map.update(acc, label, count, &(&1 + count))
      end)

    {:reply, new_state, new_state}
  end

  def via_tuple(id) do
    DistributedCounter.ProcessRegistry.via_tuple({__MODULE__, id})
  end

  def get() do
    GenServer.call(via_tuple(:counter), :get)
  end

  def increment(count, labels) do
    GenServer.call(via_tuple(:counter), {:increment, {count, labels}})
  end
end

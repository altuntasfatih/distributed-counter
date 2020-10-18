defmodule DistributedCounter do
  use GenServer
  require Logger

  def start_link(state) do
    Logger.info("Counter is starting")
    GenServer.start_link(__MODULE__, state, name: {:global, __MODULE__})
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
    new_state = update_state(state, {count, labels})
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_cast({:increment, {count, labels}}, state) do
    new_state = update_state(state, {count, labels})
    {:noreply, new_state}
  end

  defp update_state(current_state, {count, labels}) do
    labels
    |> Enum.map(&String.to_atom(&1))
    |> Enum.reduce(current_state, fn label, acc ->
      Map.update(acc, label, count, &(&1 + count))
    end)
  end

  def via_tuple() do
    :global.whereis_name(__MODULE__)
  end

  def get() do
    GenServer.call(via_tuple(), :get)
  end

  def increment(count, labels) do
    GenServer.call(via_tuple(), {:increment, {count, labels}})
  end
end

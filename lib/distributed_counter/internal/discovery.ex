defmodule DistributedCounter.Discovery do
  use GenServer
  require Logger

  @period 30_000
  def start_link(:ok) do
    state =
      Application.get_env(:distributed_counter, :discovery)
      |> create_state()
      |> discover()

    Logger.info("DiscoveryJob is starting initial state \n#{join(state)}")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Process.send_after(self(), :discover, @period)
    {:ok, state}
  end

  def handle_info(:discover, state) do
    new_state = discover(state)
    Logger.info("DiscoveryJob state \n#{join(new_state)}")
    Process.send_after(self(), :discover, @period)
    {:noreply, new_state}
  end

  def discover(state) do
    state
    |> Enum.map(fn {host, _} -> {host, Node.ping(host)} end)
  end

  def create_state(domain: domain, name: name, interval: interval) do
    Enum.to_list(interval)
    |> Enum.map(fn x -> {String.to_atom("#{name}#{x}#{domain}"), :pang} end)
    |> Enum.filter(fn {host, _} -> Node.self() != host end)
  end

  defp join(state) do
    state
    |> Enum.map(fn {host, status} -> "#{host}: #{status}" end)
    |> Enum.join("\n")
  end
end

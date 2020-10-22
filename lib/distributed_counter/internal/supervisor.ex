defmodule DistributedCounter.DiscoverySupervisor do
  use Supervisor
  require Logger

  def start_link(_) do
    Logger.info("Supervisor is starting")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [{DistributedCounter.Discovery,:ok}]
    Supervisor.init(children, strategy: :one_for_one)
  end
end

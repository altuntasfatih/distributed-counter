defmodule DistributedCounter.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_counter() do
    child_spec = {DistributedCounter, %{}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

end

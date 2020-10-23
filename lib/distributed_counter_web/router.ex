defmodule DistributedCounterWeb.Router do
  use DistributedCounterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/metrics", DistributedCounterWeb do
    pipe_through :api
    get "/", CounterController, :index
    post "/", CounterController, :increment
    get "/query", CounterController, :get
  end
end

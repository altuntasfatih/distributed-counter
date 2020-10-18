defmodule DistributedCounterWeb.CounterController do
  use DistributedCounterWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(DistributedCounter.get())
  end

  def increment(conn, %{"increment" => count, "labels" => labels})
      when count >= 0 and length(labels) > 0 do
    conn
    |> put_status(:ok)
    |> json(DistributedCounter.increment(count, labels))
  end

  def increment(conn, _) do
    conn
    |> put_status(400)
    |> put_view(DistributedCounterWeb.ErrorView)
    |> render("400.json", message: "Invalid Request")
  end
end

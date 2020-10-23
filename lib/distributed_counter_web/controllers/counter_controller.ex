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
    |> render("4XX.json", message: "Invalid Request")
  end

  def get(conn, %{"expression" => expression}) when is_binary(expression) and expression != "" do
    case DistributedCounter.query_expression(expression) do
      {:ok, response} ->
        conn
        |> put_status(:ok)
        |> json(Enum.reduce(response, %{}, fn {l, count}, acc -> Map.put(acc, l, count) end))

      {:error, message} ->
        conn
        |> put_status(404)
        |> put_view(DistributedCounterWeb.ErrorView)
        |> render("4XX.json", message: message)
    end
  end

  def get(conn, _) do
    conn
    |> put_status(:ok)
    |> json(DistributedCounter.get())
  end
end

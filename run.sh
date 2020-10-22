PORT=4000 iex --name node-1@0.0.0.0 -S mix phx.server &
PORT=4001 iex --name node-2@0.0.0.0 -S mix phx.server & 
PORT=4002 iex --name node-3@0.0.0.0 -S mix phx.server & 
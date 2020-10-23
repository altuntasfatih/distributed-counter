nohup $(PORT=4000 iex --name node-1@0.0.0.0 -S mix phx.server > node-1.log )&
nohup $(PORT=4001 iex --name node-2@0.0.0.0 -S mix phx.server > node-2.log )&
PORT=4002 iex --name node-3@0.0.0.0 -S mix phx.server

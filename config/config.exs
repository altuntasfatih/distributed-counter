# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :distributed_counter, DistributedCounterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5TjUxsMO2FXFoyutbVWApD7a/yWT2SuOnA4EgIp3pqwlr9wkwPDcawtJSoSeUQgz",
  render_errors: [view: DistributedCounterWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DistributedCounter.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "wOie26Zw"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

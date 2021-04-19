# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :desafio_softaliza,
  namespace: Ev,
  ecto_repos: [Ev.Repo]

# Configures the endpoint
config :desafio_softaliza, EvWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "V+cH7r0+f2TVjb88+I3iRAvsG73Ijdqpow/LBf7xPybv3qV9zcnYFXciqrglX0QP",
  render_errors: [view: EvWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Ev.PubSub,
  live_view: [signing_salt: "aG05GxJU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

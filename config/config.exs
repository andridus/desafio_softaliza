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

# Configura o Guardian - Lib para autenticação de usuário
config :desafio_softaliza, Ev.Guardian,
       issuer: "ev",
       secret_key: "pd7SAumZO9Hs+nuxt3l4hCIbkb2lJUB01aGF+kct3nJ9ROqSYXRfW2dY1NAPWZAC"


       # Configura o Swagger - Lib que gera a documentação api
config :desafio_softaliza, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: EvWeb.Router,     # Rotas do phoenix são converitdos em caminho swagger.
      endpoint: EvWeb.Endpoint  
    ]
  }

# Configura o PDF Generator
config :pdf_generator,
    wkhtml_path:  "/usr/bin/wkhtmltopdf"
  #  command_prefix: "/usr/bin/xvfb-run"

# Configura o Swagger para rodar em localhost
config :desafio_softaliza, EvApp.Web.Endpoint,
  url: [host: "localhost"] # "host": "localhost:4000" in generated swagger

# Configura o Swagger para usar o Jason
config :phoenix_swagger, json_library: Jason

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

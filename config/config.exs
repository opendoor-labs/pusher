# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :pusher, Pusher.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "3tjxJzs5LE13wnxONehYqRDf1mQKSaoUtzAuho4nssaZqURO8KQZtRxC5d5mGdiI",
  debug_errors: false,
  pubsub: [name: Pusher.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "Pusher",
  ttl: { 30, :days },
  verify_issuer: false,
  serializer: Pusher.GuardianSerializer,
  atoms: [:listen, :publish, :email, :name, :id]

config :honeybadger, excluded_envs: [:dev, :test]

import_config "#{Mix.env}.exs"

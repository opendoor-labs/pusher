node_name = "#{Mix.env()}#{System.os_time(:nanosecond)}"
use Mix.Config

config :pusher, Pusher.Endpoint,
  http: [port: {:system, "PORT"}],
  pubsub: [adapter: Phoenix.PubSub.Redis, url: System.get_env("REDIS_URL"), node_name: node_name],
  debug_errors: true,
  cache_static_lookup: false

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :pusher, :authentication, secret: "development"
config :guardian, Guardian, secret_key: "development"

config :honeybadger, :environment_name, :dev

node_name = "#{Mix.env()}#{System.os_time(:nanosecond)}"
use Mix.Config

config :pusher, Pusher.Endpoint,
  http: [port: {:system, "PORT"}],
  pubsub: [adapter: Phoenix.PubSub.Redis, url: System.get_env("REDIS_URL"), node_name: node_name],
  url: [host: "staging-opendoor-pusher.herokuapp.com"],
  check_origin: ["//demo.simplersell.com", "//admin.simplersell.com", "//*.herokuapp.com"],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info
config :pusher, :authentication, secret: System.get_env("SHARED_SECRET")

config :pusher, Pusher.Endpoint,
  secret_key_base: System.get_env("PUSHER_SECRET")

config :guardian, Guardian, secret_key: System.get_env("GUARDIAN_SECRET")

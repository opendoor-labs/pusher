use Mix.Config

config :pusher, Pusher.Endpoint,
  http: [port: {:system, "PORT"}],
  pubsub: [adapter: Phoenix.PubSub.Redis, url: System.get_env("REDIS_URL")],
  url: [host: "opendoor-pusher.herokuapp.com"],
  check_origin: ["//www.opendoor.com"],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info
config :pusher, :authentication, secret: System.get_env("SHARED_SECRET")
config :guardian, Guardian, secret_key: System.get_env("GUARDIAN_SECRET")

config :pusher, Pusher.Endpoint,
  secret_key_base: System.get_env("PUSHER_SECRET")

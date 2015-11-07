use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pusher, Pusher.Endpoint,
  http: [port: 4001],
  pubsub: [adapter: Phoenix.PubSub.Redis],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :pusher, :authentication, secret: "test_secret"
config :guardian, Guardian, secret_key: "test"

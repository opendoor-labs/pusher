use Mix.Config

config :pusher, Pusher.Endpoint,
  http: [ip: {127,0,0,1}, port: {:system, "PORT"}],
  pubsub: [adapter: Phoenix.PubSub.Redis],
  cache_static_lookup: true,
  server: true

# Watch static and templates for browser reloading.
config :pusher, Pusher.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :pusher, :authentication, secret: "development"
config :guardian, Guardian, secret_key: "development"

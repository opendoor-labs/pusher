defmodule Pusher.Mixfile do
  use Mix.Project

  def project do
    [app: :pusher,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Pusher, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :phoenix_pubsub, :phoenix_pubsub_redis, :honeybadger, :guardian]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 1.2"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub_redis, "~> 2.1" },
      {:cowboy, "~> 1.0"},
      {:guardian, "~> 0.12.0"},
      {:exrm, "~> 1.0"},
      {:honeybadger, "~> 0.6"},
    ]
  end
end

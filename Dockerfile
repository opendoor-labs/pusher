# keep in sync with elixir_buildpack.config
FROM elixir:1.4.5

RUN mkdir -p /app
WORKDIR /app

COPY . /app

ENV MIX_ENV=docker
ENV PORT=8585

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix release

CMD ["/usr/local/bin/elixir", "-S", "mix", "phoenix.server"]

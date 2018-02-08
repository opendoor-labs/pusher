FROM elixir:1.5

RUN mkdir -p /app
WORKDIR /app

COPY . /app

ENV MIX_ENV=docker

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix release

CMD ["/usr/local/bin/elixir", "-S", "mix", "phoenix.server"]
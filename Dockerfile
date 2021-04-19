FROM hexpm/elixir:1.10.2-erlang-22.2.8-alpine-3.11.3

RUN apk add inotify-tools unzip tar
RUN adduser -S --home /home/app  user --uid 1000
WORKDIR /home/app

# Cache elixir deps
USER user
RUN mix local.hex --force
RUN mix local.rebar --force
COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mix deps.compile


CMD ["iex", "-S", "mix", "phx.server"]
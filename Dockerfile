FROM hexpm/elixir:1.10.2-erlang-22.2.8-alpine-3.11.3

RUN apk add --no-cache inotify-tools unzip tar xvfb
RUN apk add  --no-cache --repository  http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ wkhtmltopdf=0.12.5-r0
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
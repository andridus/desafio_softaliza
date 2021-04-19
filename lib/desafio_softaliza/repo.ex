defmodule Ev.Repo do
  use Ecto.Repo,
    otp_app: :desafio_softaliza,
    adapter: Ecto.Adapters.Postgres
end

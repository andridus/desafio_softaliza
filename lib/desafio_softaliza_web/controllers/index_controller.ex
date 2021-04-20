defmodule EvWeb.IndexController do
  use Phoenix.Controller

  def index(conn, _params) do
    conn
    |> json %{success: true, datetime: NaiveDateTime.utc_now}
  end
end
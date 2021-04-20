defmodule Ev.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.Errorhandler
  
  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!%{ status: false, msg: "UNAUTHENTICATED"}
    
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(403, body)
  end
end

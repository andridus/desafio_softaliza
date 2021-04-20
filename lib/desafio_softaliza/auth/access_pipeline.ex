defmodule Ev.Auth.AccessPipeline do
  use Guardian.Plug.Pipeline, 
    otp_app: :desafio_softaliza,
    error_handler: Ev.Auth.ErrorHandler,
    module: Ev.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
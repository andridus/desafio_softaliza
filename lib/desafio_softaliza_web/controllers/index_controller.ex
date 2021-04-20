defmodule EvWeb.IndexController do
  use Phoenix.Controller
  use PhoenixSwagger


  swagger_path :index do
    get "/v1"
    summary "Rota de Verificação"
    description "Rota de Verificação que apresenta a data e hora local."
    produces "application/json"
    tag "Test"
    operation_id "show_test"
    response 200, "OK", Schema.ref(:Test)
    response 400, "Client Error"
  end
  def index(conn, _params) do
    conn
    |> json %{datetime: NaiveDateTime.utc_now}
  end




  def swagger_definitions do
    %{
      Test: swagger_schema do
        title "Test"
        description "A página de teste que mostra a data e a hora atual"
        properties do
          datetime :string, "Data e Hora"
        end
        example %{
          datetime: "2021-04-20T00:35:10.163600"
        }
      end
    }
  end
end
defmodule EvWeb.EventsController do
  use Phoenix.Controller
  use PhoenixSwagger

  alias Ev.Models.{ Event }

  # Cadastra um novo evento baseado nos parametros
  ### DEFINICAO DO SWAGGER ###
  swagger_path :create do
    post "/v1/events"
    summary "Cadastra um event"
    description "Cadastra um novo evento no banco de dados."
    produces "application/json"
    tag "Events"
    operation_id "create_event"
    security [%{Bearer: []}]
    parameters do
      data :body, (Schema.new do
          properties do
            title :string, "Título do Evento", default: true
            description :string, "Descrição do Evento", default: true
          end
        end), "Atributos do Evento", required: true
    end
    
    response 201, "OK", Schema.ref(:Event)
    response 400, "ERRORS"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def create(conn, data) do
    conn
    |> Ev.Guardian.Plug.current_resource
    |> case do
      nil -> 
        conn
        |> put_status(403)
        |> json %{success: false, msg: "FORBIDDEN"}
      user ->
        Event.create(user.id, data)
        |> case do
          {:ok, e} ->
            conn
            |> json(Event.json(e))
          {:error, changeset} ->
            conn
            |> put_status(400)
            |> json Ev.Utils.model_errors(changeset)
        end
    end
  end

  # Atualiza um evento existente
  ### DEFINICAO DO SWAGGER ###
  swagger_path :update do
    put "/v1/events/{event_id}"
    summary "Atualiza um evento"
    description "Atualiza um evento existente no banco de dados."
    produces "application/json"
    tag "Events"
    operation_id "update_event"
    security [%{Bearer: []}]
    parameters do
      event_id :path, :string, "ID do Evento", required: true
      data :body, (Schema.new do
          properties do
            title :string, "Título do Evento", default: true
            description :string, "Descrição do Evento", default: true
          end
        end), "Atributos do Evento", required: true
    end
    response 200, "OK"
    response 404, "NOT-FOUND"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def update(conn, %{"id" => id} = data) do
    Event.update(id, data)
    |> case do
      {:ok, event} ->
        conn
        |> json(Event.json(event))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> json Ev.Utils.model_errors(changeset)
    end
  end

  # Obtem as informações de um evento 
  ### DEFINICAO DO SWAGGER ###
  swagger_path :proceedings do
    get "/v1/events/{event_id}/proceedings"
    summary "Obtém os anais de um evento"
    description "Obtém os anais de um evento existente no banco de dados."
    produces "application/json"
    tag "Events"
    operation_id "proceedings_event"
    parameters do
      event_id :path, :string, "ID do Evento", required: true
    end
    response 200, "OK", Schema.ref(:Event)
    response 404, "NOT-FOUND"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def proceedings(conn, %{"id"=>id}) do
    Event.get(id)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json %{success: false, msg: "NOT-FOUND" }
      e ->
        pdf_content = Event.proceedings(e)
        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header("content-disposition", "attachment; filename=\"EVENT-PROCEEEDINGS.pdf\"")
        |> send_resp(200, pdf_content)
    end
  end

  # Obtem as informações de um evento 
  ### DEFINICAO DO SWAGGER ###
  swagger_path :one do
    get "/v1/events/{event_id}"
    summary "Obtém um evento"
    description "Obtém um evento existente no banco de dados."
    produces "application/json"
    tag "Events"
    operation_id "one_event"
    parameters do
      event_id :path, :string, "ID do Evento", required: true
    end
    response 200, "OK", Schema.ref(:Event)
    response 404, "NOT-FOUND"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def one(conn, %{"id"=>id}) do
    Event.get(id)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json %{success: false, msg: "NOT-FOUND" }
      u ->
        conn
        |> json(Event.json(u))
    end
  end

  # Obtem as informações de todos os eventos 
  ### DEFINICAO DO SWAGGER ###
  swagger_path :all do
    get "/v1/events/"
    summary "Lista todos os eventos"
    description "Lista todos eventos existente no banco de dados."
    produces "application/json"
    tag "Events"
    operation_id "all_events"
    response 200, "OK", Schema.ref(:Events)
    response 401, "UNAUTHENTICATED"
  end
  ### DEFINICAO DA ROTA ###
  def all(conn, _params) do
    
    events = Event.all() |> Enum.map(&Event.json/1)

    conn
    |> json events
  end


  # Remove um evento
  ### DEFINICAO DO SWAGGER ###
   swagger_path :remove do
    delete "/v1/events/{event_id}"
    summary "Remove um evento"
    description "Remove um evento existente no banco de dados."
    produces "application/json"
    tag "Events"
    operation_id "remove_event"
    security [%{Bearer: []}]
    parameters do
      event_id :path, :string, "ID do Evento", required: true
    end
    response 200, "OK",(Schema.new do
          properties do
            event Schema.ref(:Event)
            success :boolean, "Verdadeiro para remoção de evento", default: true
          end
        end)
    response 404, "NOT-FOUND"
    response 401, "UNAUTHENTICATED"
  end
  ### DEFINICAO DA ROTA ###
  def remove(conn, %{"id" => id}) do
    Event.remove(id)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json %{success: false, msg: "NOT-FOUND"}
      {:ok, u} ->
        conn
        |> json %{success: true, event: Event.json(u)}
      {:error, err} ->
        conn
        |> put_status(400)
        |> json err
    end
  end



  ### DEFINICÕES DE MODELO DO SWAGGER ###
  def swagger_definitions do
    %{
      Event: swagger_schema do
        title "Evento"
        description "Um Evento cadastrado"
        properties do
          title :string, "Título", required: true
          description :string, "Descrição", required: true
          creator_id :integer, "ID do criador"
          id :integer, "Identificado Único"
        end
        example %{
          id: 123,
          title: "Evento Teste",
          description: "Um Evento de Teste"
        }
      end,
      Events: swagger_schema do
        title "Eventos"
        description "Uma lista de eventos"
        type :array
        items Schema.ref(:Event)
      end
      
    }
  end
end
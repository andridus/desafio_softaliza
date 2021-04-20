defmodule EvWeb.UsersController do
  use Phoenix.Controller
  use PhoenixSwagger

  alias Ev.Models.{ User }

  # Cadastra um novo usuário baseado nos parametros
  ### DEFINICAO DO SWAGGER ###
  swagger_path :create do
    post "/v1/users"
    summary "Cadastra um usuário"
    description "Cadastra um novo usuário no banco de dados."
    produces "application/json"
    tag "Users"
    operation_id "create_user"
    security [%{Bearer: []}]
    parameters do
      data :body, (Schema.new do
          properties do
            name :string, "Nome do Usuário", default: true
            email :string, "Email do Usuário", default: true
            password :string, "Senha do Usuário", default: true
          end
        end), "Atributos do Usuário", required: true
    end
    
    response 201, "OK", Schema.ref(:User)
    response 400, "ERRORS"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def create(conn, data) do
    User.create(data)
    |> case do
      {:ok, u} ->
        conn
        |> json(User.json(u))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> json Ev.Utils.model_errors(changeset)
    end
  end

  # Atualiza um usuário existente
  ### DEFINICAO DO SWAGGER ###
  swagger_path :update do
    put "/v1/events/{event_id}"
    summary "Atualiza um"
    description "Atualiza um usuário existente no banco de dados."
    produces "application/json"
    tag "Users"
    operation_id "update_user"
    security [%{Bearer: []}]
    parameters do
      user_id :path, :string, "ID do Usuário", required: true
      data :body, (Schema.new do
          properties do
            name :string, "Nome do Usuário", default: true
          end
        end), "Atributos do Usuário", required: true
    end
    response 200, "OK", Schema.ref(:User)
    response 404, "NOT-FOUND"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def update(conn, %{"id" => id} = data) do
    User.update(id, data)
    |> case do
      {:ok, u} ->
        conn
        |> json(User.json(u))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> json Ev.Utils.model_errors(changeset)
    end
  end

  # Obtem as informações de um usuário 
  ### DEFINICAO DO SWAGGER ###
  swagger_path :one do
    get "/v1/users/{user_id}"
    summary "Obtém um usuário"
    description "Obtém um usuário existente no banco de dados."
    produces "application/json"
    tag "Users"
    operation_id "one_user"
    security [%{Bearer: []}]
    parameters do
      user_id :path, :string, "ID do Usuário", required: true
    end
    response 200, "OK", Schema.ref(:User)
    response 404, "NOT-FOUND"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def one(conn, %{"id"=>id}) do
    User.get(id)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json %{success: false, msg: "NOT-FOUND" }
      u ->
        conn
        |> json(User.json(u))
    end
  end

  # Obtem as informações de todos os usuário 
  ### DEFINICAO DO SWAGGER ###
  swagger_path :all do
    get "/v1/users/"
    summary "Lista todos os usuários"
    description "Lista todos usuário existente no banco de dados."
    produces "application/json"
    tag "Users"
    operation_id "all_user"
    security [%{Bearer: []}]
    response 200, "OK", Schema.ref(:Users)
    response 401, "UNAUTHENTICATED"
  end
  ### DEFINICAO DA ROTA ###
  def all(conn, _params) do
    
    users = User.all() |> Enum.map(&User.json/1)

    conn
    |> json users
  end


  # Remove um usuário
  ### DEFINICAO DO SWAGGER ###
   swagger_path :remove do
    delete "/v1/users/{user_id}"
    summary "Remove um usuário"
    description "Remove um usuário existente no banco de dados."
    produces "application/json"
    tag "Users"
    operation_id "remove_user"
    security [%{Bearer: []}]
    parameters do
      user_id :path, :string, "ID do Usuário", required: true
    end
    response 200, "OK",(Schema.new do
          properties do
            user Schema.ref(:User)
            success :boolean, "Verdadeiro para remoção de usuário", default: true
          end
        end)
    response 404, "NOT-FOUND"
    response 401, "UNAUTHENTICATED"
  end
  ### DEFINICAO DA ROTA ###
  def remove(conn, %{"id" => id}) do
    User.remove(id)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json %{success: false, msg: "NOT-FOUND"}
      {:ok, u} ->
        conn
        |> json %{success: true, user: User.json(u)}
      {:error, err} ->
        conn
        |> put_status(400)
        |> json err
    end
  end



  ### DEFINICÕES DE MODELO DO SWAGGER ###
  def swagger_definitions do
    %{
      User: swagger_schema do
        title "Usuário"
        description "Um Usuário cadastrado"
        properties do
          name :string, "Nome", required: true
          email :string, "E-mail", required: true
          id :integer, "Identificado Único"
        end
        example %{
          id: 123,
          name: "Fulano de Tal",
          email: "fulano@mail.com"
        }
      end,
      Users: swagger_schema do
        title "Usuários"
        description "Uma lista de usuários"
        type :array
        items Schema.ref(:User)
      end
      
    }
  end
end
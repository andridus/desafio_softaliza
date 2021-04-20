defmodule EvWeb.SessionController do
  use Phoenix.Controller
  use PhoenixSwagger


  alias Ev.Models.{ User }

  # Rota para efetuar o login
  swagger_path :login do
    post "/v1/login"
    summary "Efetuar o Login "
    description "Efetue o login com usuário e senha."
    produces "application/json"
    tag "Session"
    operation_id "login_auth"
    parameters do
      username :query, :string, "E-mail do usuário", required: true, example: "fulano@email.com"
      password :query, :string, "A senha de acesso cadastrada na conta do usuário ", required: true
    end
    response 200, "OK", (Schema.new do
          properties do
            user (Schema.new do
              properties do
                name :string, "Nome do Usuário", default: true
                email :string, "Email do Usuário", default: true
              end
            end)
            jwt :string, "Token", default: true
            claims :string, "Claims", default: true
          end
        end)
    response 404, "NOT-FOUND-USER"
    response 400, "USER-OR-PASSWORD-INVALID"
   
  end
  def login(conn, %{"username" => email, "password" => password }) do
    User.get_by_email(email)
    |> case do
      nil ->
        conn 
        |> json %{success: false, msg: "NOT-FOUND-USER"}
      user ->
        # Verifica se as senhas são equivalentes
        if User.verify_password(user, password) do
          conn1 = Ev.Guardian.Plug.sign_in(conn, user)
          token = Ev.Guardian.Plug.current_token(conn1)
          claims = Ev.Guardian.Plug.current_claims(conn1)

          json conn1, %{
              success: true,
              data: %{
                user: User.json(user),
                jwt: token,
                claims: claims,
              }
            }

        else
          conn 
          |> json %{success: false, msg: "USER-OR-PASSWORD-INVALID"}
        end
    end
  end



  # Registra um novo usuário baseado nos parametros redirecionando para a função UserController.create
  swagger_path :signup do
    post "/v1/signup"
    summary "Registra um novo usuário"
    description "Registra  um novo usuário no banco de dados."
    produces "application/json"
    tag "Session"
    operation_id "register_user"
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
    response 400, "INVALID-REQUEST"
  end
  def signup(conn, params),  do: EvWeb.UsersController.create(conn, params)

end
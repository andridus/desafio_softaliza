defmodule EvWeb.ArticlesController do
  use Phoenix.Controller
  use PhoenixSwagger

  alias Ev.Models.{ Article }

  # Cadastra um novo article baseado nos parametros
  ### DEFINICAO DO SWAGGER ###
  swagger_path :create do
    post "/v1/articles"
    summary "Cadastra um Artigo"
    description "Cadastra um novo artigo no banco de dados."
    produces "application/json"
    tag "Articles"
    operation_id "create_article"
    security [%{Bearer: []}]
    parameters do
      data :body, (Schema.new do
          properties do
            title :string, "Título do Artigo"
            abstract :string, "Resumo do Artigo"
            coauthors :array, "Lista de Nomes"
            keywords :array, "Lista de palavras-chave"
            event_id :integer, "Id do Artigo"
          end
        end), "Atributos do Artigo", required: true
    end
    
    response 201, "OK", Schema.ref(:Article)
    response 400, "ERRORS"
    response 403, "FORBIDDEN"
    response 404, "EVENT-NOT-FOUND"
  end
  ### DEFINICAO DA ROTA ###
  def create(conn, data) do
    conn
    |> Ev.Guardian.Plug.current_resource
    |> case do
      nil -> 
        conn
        |> put_status(404)
        |> json %{success: false, msg: "FORBIDDEN"}
      user ->
        Article.create(user.id, data)
        |> case do
          nil ->
            conn
            |> put_status(404)
            |> json %{success: false, msg: "EVENT-NOT-FOUND"}
          {:ok, e} ->
            conn
            |> json(Article.json(e))
          {:error, changeset} ->
            conn
            |> put_status(400)
            |> json Ev.Utils.model_errors(changeset)
        end
    end
  end

  # Atualiza um artigo existente
  ### DEFINICAO DO SWAGGER ###
  swagger_path :update do
    put "/v1/article/{article_id}"
    summary "Atualiza um artigo"
    description "Atualiza um artigo existente no banco de dados."
    produces "application/json"
    tag "Articles"
    operation_id "update_article"
    security [%{Bearer: []}]
    parameters do
      article_id :path, :string, "ID do Artigo", required: true
      data :body, (Schema.new do
          properties do
            title :string, "Título do Artigo"
            abstract :string, "Resumo do Artigo"
            coauthors :array, "Lista de Nomes"
            keywords :array, "Lista de palavras-chave"
          end
        end), "Atributos do Artigo", required: true
    end
    response 200, "OK", Schema.ref(:Article)
    response 404, "NOT-FOUND"
    response 403, "FORBIDDEN"
    response 400, "ERRORS"
  end
  ### DEFINICAO DA ROTA ###
  def update(conn, data) do
    id = data["id"]
    Article.update(id, data)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json(%{sucess: false, msg: "NOT-FOUND"})
      {:ok, event} ->
        conn
        |> json(Article.json(event))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> json Ev.Utils.model_errors(changeset)
    end
  end

  # Obtem as informações de um usuário 
  ### DEFINICAO DO SWAGGER ###
  swagger_path :one do
    get "/v1/articles/{article_id}"
    summary "Obtém um artigo"
    description "Obtém um artigo existente no banco de dados."
    produces "application/json"
    tag "Articles"
    operation_id "one_article"
    parameters do
      article_id :path, :string, "ID do Artigo", required: true
    end
    response 200, "OK", Schema.ref(:Article)
    response 404, "NOT-FOUND"
    response 403, "FORBIDDEN"
  end
  ### DEFINICAO DA ROTA ###
  def one(conn, %{"id"=>id}) do
    Article.get(id)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json %{success: false, msg: "NOT-FOUND" }
      u ->
        conn
        |> json(Article.json(u))
    end
  end

  # Obtem as informações de todos os artigos 
  ### DEFINICAO DO SWAGGER ###
  swagger_path :all do
    get "/v1/articles/"
    summary "Lista todos os artigos"
    description "Lista todos artigos existente no banco de dados."
    produces "application/json"
    tag "Articles"
    operation_id "all_articles"
    response 200, "OK", Schema.ref(:Article)
    response 401, "UNAUTHENTICATED"
  end
  ### DEFINICAO DA ROTA ###
  def all(conn, _params) do
    
    articles = Article.all() |> Enum.map(&Article.json/1)

    conn
    |> json articles
  end


  # Remove um artigo
  ### DEFINICAO DO SWAGGER ###
   swagger_path :remove do
    delete "/v1/articles/{event_id}"
    summary "Remove um artigo"
    description "Remove um artigo existente no banco de dados."
    produces "application/json"
    tag "Articles"
    operation_id "remove_event"
    security [%{Bearer: []}]
    parameters do
      event_id :path, :string, "ID do Artigo", required: true
    end
    response 200, "OK",(Schema.new do
          properties do
            event Schema.ref(:Article)
            success :boolean, "Verdadeiro para remoção de artigo", default: true
          end
        end)
    response 404, "NOT-FOUND"
    response 401, "UNAUTHENTICATED"
  end
  ### DEFINICAO DA ROTA ###
  def remove(conn, %{"id" => id}) do
    Article.remove(id)
    |> case do
      nil ->
        conn
        |> put_status(404)
        |> json %{success: false, msg: "NOT-FOUND"}
      {:ok, u} ->
        conn
        |> json %{success: true, event: Article.json(u)}
      {:error, err} ->
        conn
        |> put_status(400)
        |> json err
    end
  end



  ### DEFINICÕES DE MODELO DO SWAGGER ###
  def swagger_definitions do
    %{
      Article: swagger_schema do
        title "Artigo"
        description "Um artigo cadastrado"
        properties do
          title :string, "Título do Artigo", required: true
          abstract :string, "Resumo do Artigo", required: true
          coauthors :array, "Lista de Nomes"
          keywords :array, "Lista de palavras-chave", required: true
          event_id :integer, "Id do Articleo", required: true
        end
        example %{
          id: 123,
          title: "Artigo teste",
          abstract: "Um Artigo de Teste",
          coauthors: [],
          keywords: ["teste", "artigo"],
          event_id: 1
        }
      end,
      Articles: swagger_schema do
        title "Artigos"
        description "Uma lista de artigos"
        type :array
        items Schema.ref(:Article)
      end
      
    }
  end
end
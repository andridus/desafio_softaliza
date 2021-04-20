defmodule EvWeb.Router do
  use EvWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline, module: Ev.Guardian, error_handler: Ev.Auth.ErrorHandler
  end
  
  pipeline :authed do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", EvWeb do
    pipe_through [:api, :auth]

    get "/", IndexController, :index
  end

  #Rotas API Públicas
  scope "/v1", EvWeb do
    pipe_through [:api, :auth]

    get "/", IndexController, :index
  end

  #Rotas API que necessitam de autenticação
  scope "/v1", EvWeb do
    pipe_through [:api, :auth, :authed]

    get "/app", IndexController, :index
  end

  # Rotas do UI do Swagger
  def swagger_info do
    %{
      schemes: ["http", "https", "ws", "wss"],
      info: %{
        version: "1.0",
        title: "Desafio Softaliza",
        description: "Documentação da API do Desafio Softaliza v1",
        termsOfService: "Aberto",
        contact: %{
          name: "Helder de Sousa",
          email: "helderhenri@gmail.com"
        }
      },
      securityDefinitions: %{
        Bearer: %{
          type: "token",
          name: "Authorization",
          description: "O token para acesso à API deve ser inserido no Header da requisição `Authorization: Bearer {token} ` ",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{name: "Users", description: "Recursos de Usuários"},
        %{name: "Proceedings", description: "Recursos de Anais"},
        %{name: "Events", description: "Recursos de Eventos"},
        %{name: "Articles", description: "Recursos de Artigos"},
      ]
    }
  end
  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :desafio_softaliza, swagger_file: "swagger.json"
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: EvWeb.Telemetry
    end
  end
end

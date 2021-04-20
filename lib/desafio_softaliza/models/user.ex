defmodule Ev.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ev.Repo
  import Ecto.Query

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string

    timestamps()

    has_many :events, Ev.Models.Event, foreign_key: :creator_id
    has_many :articles, Ev.Models.Article, foreign_key: :author_id  
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, name: :index_for_duplicate_entries)

  end

  # criptografa a senha
  def crypted(password) do
    :crypto.hash(:sha, password) |> Base.encode16
  end

  # Verifica a igualdade da senha de acesso
  def verify_password(user,password) do
    if is_nil(user.password) do
        false
    else
        String.upcase(user.password) == crypted(password)
    end
  end

  # Retorna o JSON do Usuário
  def json(nil), do: nil
  def json(data) do
    u = Map.take(data, [:id, :name, :email])

    # Retorna os eventos criados pelo usuário, se feito o preload
    events = 
      if Ecto.assoc_loaded?(data.events) do
        Enum.map data.events, &Ev.Models.Event.json/1
      else
        []
      end
    Map.merge(u, %{events: events})
  end

  # Obtem o usuário pelo Id
  def get_by_email(email) do
    __MODULE__
    |> Repo.get_by(email: email)
  end

  # Obtem o usuário pelo Id
  def get(nil), do: nil
  def get(id) do
    __MODULE__
    |> Repo.get(id)
  end
  
  # Obtem todos os usuários
  def all() do
    from(u in __MODULE__)
    |> Repo.all
  end

  # Cria um novo usuário
  def create(data) do
    %__MODULE__{}
    |> __MODULE__.changeset(%{
        name: data["name"],
        email: data["email"],
        password: crypted(data["password"])
    })
    |> Repo.insert
  end

  # Atualiza um usuário existente
  def update(id, data) do
    __MODULE__.get(id)
    |> case do
      nil -> nil
      user ->
        user
        |> __MODULE__.changeset(%{
            name: data["name"]
        })
        |> Repo.update
    end
  end

  # Remove um usuário existente
  def remove(id) do
    __MODULE__.get(id)
    |> case do
      nil ->
        nil
      u ->
        Repo.delete(u)
    end
  end
end

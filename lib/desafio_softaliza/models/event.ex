defmodule Ev.Models.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ev.Repo
  import Ecto.Query

  schema "events" do
    field :description, :string
    field :title, :string

    timestamps()

    belongs_to :creator, Ev.Models.User, foreign_key: :creator_id    
  end

  @doc false
  def changeset(events, attrs) do
    events
    |> cast(attrs, [:title, :description, :creator_id])
    |> validate_required([:title, :description, :creator_id])
  end

  # Retorna o JSON do evento
  def json(nil), do: nil
  def json(data) do
    u = Map.take(data, [:id, :title, :description])
    creator = 
      if Ecto.assoc_loaded?(data.creator) do
        Ev.Models.User.json(data.creator)
      else
        nil
      end
    Map.merge(u, %{creator: creator})
  end

  # Obtem o evento pelo Id
  def get(id) do
    (from e in __MODULE__, preload: [:creator] )
    |> Repo.one()
  end
  
  # Obtem todos os eventos
  def all() do
    from(u in __MODULE__, preload: [:creator] )
    |> Repo.all
  end

  # Cria um novo evento
  def create(creator_id, data) do
    %__MODULE__{}
    |> __MODULE__.changeset(%{
        title: data["title"],
        description: data["description"],
        creator_id: creator_id
    })
    |> Repo.insert
  end

  # Atualiza um evento existente
  def update(id, data) do
    __MODULE__.get(id)
    |> case do
      nil -> nil
      e ->
        e |> __MODULE__.changeset(%{
            title: data["title"],
          description: data["description"],
        })
        |> Repo.update
    end
  end

  # Remove um evento existente
  def remove(id) do
    __MODULE__.get(id)
    |> case do
      nil ->
        nil
      e ->
        Repo.delete(e)
    end
  end
end

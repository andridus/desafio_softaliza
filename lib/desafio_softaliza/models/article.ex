defmodule Ev.Models.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ev.Repo
  import Ecto.Query

  schema "articles" do
    field :title, :string
    field :abstract, :string
    field :coauthors, {:array, :string}
    field :keywords, {:array, :string}

    timestamps()

    belongs_to :author, Ev.Models.User, foreign_key: :author_id
    belongs_to :event, Ev.Models.Event, foreign_key: :event_id

  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :abstract, :keywords, :author_id, :event_id, :coauthors])
    |> validate_required([:title, :abstract, :keywords, :author_id, :event_id])
    
  end


  # Retorna o JSON do artigo
  def json(nil), do: nil
  def json(data) do
    article = Map.take(data, [:id, :title, :abstract, :coauthors, :keywords])
    author = 
      if Ecto.assoc_loaded?(data.author) do
        Ev.Models.User.json(data.author)
      else
        nil
      end
    event = 
      if Ecto.assoc_loaded?(data.event) do
        Ev.Models.Event.json(data.event)
      else
        nil
      end
    Map.merge(article, %{author: author, event: event})
  end

  # Obtem o artigo pelo Id
  def get(nil), do: nil
  def get(id) do
    (from a in __MODULE__, where: a.id == ^id, preload: [:author, :event] )
    |> Repo.one()
  end
  
  # Obtem todos os artigos
  def all() do
    from(u in __MODULE__, preload: [:author, :event] )
    |> Repo.all
  end

  # Cria um novo artigo
  def create(author_id, data) do
    IO.inspect data
    Ev.Models.Event.get(data["event_id"])
    |> case do
      nil ->
        nil
      event ->
        %__MODULE__{}
        |> __MODULE__.changeset(%{
            title: data["title"],
            abstract: data["abstract"],
            coauthors: data["coauthors"],
            keywords: data["keywords"],
            event_id: event.id,
            author_id: author_id
        })
        |> Repo.insert
    end
  end

  # Atualiza um artigo existente
  def update(id, data) do
    __MODULE__.get(id)
    |> case do
      nil -> nil
      e ->
        e |> __MODULE__.changeset(%{
          title: data["title"],
          abstract: data["abstract"],
          coauthors: data["coauthors"],
          keywords: data["keywords"],
        })
        |> Repo.update
    end
  end

  # Remove um artigo existente
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

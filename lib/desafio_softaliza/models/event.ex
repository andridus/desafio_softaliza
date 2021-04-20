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
    has_many :articles, Ev.Models.Article, foreign_key: :event_id  
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
    event = Map.take(data, [:id, :title, :description])
    creator = 
      if Ecto.assoc_loaded?(data.creator) do
        Ev.Models.User.json(data.creator)
      else
        nil
      end

    articles = 
      if Ecto.assoc_loaded?(data.articles) do
        Enum.map(data.articles, &Ev.Models.Article.json/1)
      else
        []
      end
    Map.merge(event, %{creator: creator, articles: articles})
  end

  # Obtem o evento pelo Id
  def get(nil), do: nil
  def get(id) do
    (from e in __MODULE__, where: e.id == ^id, preload: [:creator] )
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

  # Devolve os anais de um evento
  def proceedings(e) do
    articles = (from a in Ev.Models.Article, preload: [:author])
    Repo.preload(e, [articles: articles])
    |> sort_asc_coauthors_articles
    |> gen_proceedings_pdf
  end

  def sort_asc_coauthors_articles(e) do
    
    articles = 
      e.articles
      |> Enum.sort_by(&(&1.title), :asc)
      |> Enum.map( fn 
        %Ev.Models.Article{ coauthors: c } = x when not is_nil(c) -> Map.merge(x, %{coauthors: Enum.sort(c, :asc)})
        x -> x
      end)
    Map.merge(e, %{articles: articles})
    
  end

  def gen_proceedings_pdf(event) do
    html = Utils.ProceedingTemplate.render(event)
    (PdfGenerator.generate_binary html)
    |> case do
      {:ok, bin} -> bin
      e -> false
    end
  end

  
end

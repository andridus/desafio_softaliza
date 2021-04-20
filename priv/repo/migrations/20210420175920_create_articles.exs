defmodule Ev.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :abstract, :text
      add :keywords, {:array, :string}
      add :coauthors, {:array, :string}
    
      add :author_id, references("users", column: :id)
      add :event_id, references("events", column: :id)

      timestamps()
    end

  end
end

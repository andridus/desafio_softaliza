defmodule Ev.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :text
      
      add :creator_id, references("users", column: :id)

      timestamps()
    end

  end
end

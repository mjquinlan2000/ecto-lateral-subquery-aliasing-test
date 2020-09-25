defmodule Dwight.Repo.Migrations.AddTables do
  use Ecto.Migration

  def change do
    create table("bears") do
      timestamps()
    end

    create table("beets") do
      add(:bear_id, references("bears"), null: false)
      timestamps()
    end

    create table("battlestars") do
      add(:beet_id, references("beets"), null: false)
      timestamps()
    end
  end
end

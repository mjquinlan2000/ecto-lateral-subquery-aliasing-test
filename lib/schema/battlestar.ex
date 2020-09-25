defmodule Dwight.Schema.Battlestar do
  use Ecto.Schema

  schema "battlestars" do
    belongs_to(:beet, Dwight.Schema.Beet)

    timestamps(type: :utc_datetime_usec)
  end
end

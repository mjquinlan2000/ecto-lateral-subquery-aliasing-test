defmodule Dwight.Schema.Beet do
  use Ecto.Schema

  schema "beets" do
    belongs_to(:bear, Dwight.Schema.Bear)
    has_many(:battlestars, Dwight.Schema.Battlestar)

    timestamps(type: :utc_datetime_usec)
  end
end

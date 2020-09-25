defmodule Dwight.Schema.Bear do
  use Ecto.Schema

  schema "bears" do
    has_many(:beets, Dwight.Schema.Beet)

    timestamps(type: :utc_datetime_usec)
  end
end

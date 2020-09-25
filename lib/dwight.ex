defmodule Dwight do
  import Ecto.Query
  alias Dwight.{Repo, Schema}

  def run do
    battlestars_subquery =
      Schema.Battlestar
      |> where([bs], bs.beet_id == parent_as(:beet).id)
      |> order_by([bs], desc: bs.inserted_at)
      |> distinct([bs], bs.beet_id)

    beets_subquery =
      Schema.Beet
      |> from(as: :beet)
      |> join(:inner_lateral, [beet], bs in subquery(battlestars_subquery),
        on: bs.beet_id == beet.id,
        as: :battlestar
      )
      |> where([beet], parent_as(:bear).id == beet.bear_id)
      |> distinct([beet], beet.bear_id)
      |> order_by([beet], desc: beet.inserted_at)
      |> select([beet, battlestar: bs], %{
        bear_id: beet.bear_id,
        beet_inserted_at: beet.inserted_at,
        battlestar_inserted_at: bs.inserted_at
      })

    query =
      Schema.Bear
      |> from(as: :bear)
      |> join(:inner_lateral, [bear], beet in subquery(beets_subquery),
        on: bear.id == beet.bear_id,
        as: :beet
      )
      |> select([bear, beet: beet], %{
        id: bear.id,
        bear_inserted_at: bear.inserted_at,
        beet_inserted_at: beet.beet_inserted_at,
        battlestar_inserted_at: beet.battlestar_inserted_at
      })

    Ecto.Adapters.SQL.to_sql(:all, Repo, query) |> elem(0) |> IO.puts()
  end
end

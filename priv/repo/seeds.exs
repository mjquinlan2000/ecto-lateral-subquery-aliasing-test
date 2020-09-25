alias Dwight.{Repo, Schema}

empty_map = fn -> %{inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()} end

merge_map = fn params -> Map.merge(empty_map.(), params) end

bears_params =
  empty_map
  |> Stream.repeatedly()
  |> Enum.take(10)

{_, bears} = Repo.insert_all(Schema.Bear, bears_params, returning: true)

beets_params = Enum.flat_map(bears, fn bear ->
  params = fn -> merge_map.(%{bear_id: bear.id}) end

  params
  |> Stream.repeatedly()
  |> Enum.take(10)
end)

{_, beets} = Repo.insert_all(Schema.Beet, beets_params, returning: true)

battlestar_params = Enum.flat_map(beets, fn beet ->
  params = fn -> merge_map.(%{beet_id: beet.id}) end

  params
  |> Stream.repeatedly()
  |> Enum.take(10)
end)

Repo.insert_all(Schema.Battlestar, battlestar_params)

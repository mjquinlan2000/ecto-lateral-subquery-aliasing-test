# Problem with Ecto aliasing in lateral joins

The same alias will be generated twice when using lateral joins in ecto

## Instructions for setting up the app

1. Install elixir 1.10.4, erlang 20.3 (asdf used on my machine)
2. Run postgres (docker-compose up)
3. Run `mix do ecto.create, ecto.migrate`
4. Seed the db `mix run priv/repo/seeds.exs`
4. Boot the shell with `iex -S mix` and run `Dwight.run()`

You will see the generated query. This is created by doing two levels of sub selects with lateral joins. See `Dwight.run/0` for more details. You will also notice that the query returns 0 results which on its face looks incorrect. This issue is explained in the next section

## Bad SQL output

The sql generated uses the same alias `sb0` for both `beets` and `battlestars` and because the joins are lateral, the joins execute on the wrong tables as explained below

```sql
SELECT b0."id",
         b0."inserted_at",
         s1."beet_inserted_at",
         s1."battlestar_inserted_at"
FROM "bears" AS b0
INNER JOIN LATERAL 
    (SELECT DISTINCT
        ON (sb0."bear_id") sb0."bear_id" AS "bear_id", sb0."inserted_at" AS "beet_inserted_at", ss1."inserted_at" AS "battlestar_inserted_at"
    -- First alias of sb0
    FROM "beets" AS sb0
    INNER JOIN LATERAL 
        (SELECT DISTINCT
            ON (sb0."beet_id") sb0."id" AS "id", sb0."beet_id" AS "beet_id", sb0."inserted_at" AS "inserted_at", sb0."updated_at" AS "updated_at"
        -- Second alias of sb0
        FROM "battlestars" AS sb0
        WHERE (sb0."beet_id" = sb0."id")
        ORDER BY  sb0."beet_id", sb0."inserted_at" DESC) AS ss1
            ON ss1."beet_id" = sb0."id"
        -- This will always be wrong because there is no `bear_id` on `battlestars`
        WHERE (b0."id" = sb0."bear_id")
        ORDER BY  sb0."bear_id", sb0."inserted_at" DESC) AS s1
        ON b0."id" = s1."bear_id"
```
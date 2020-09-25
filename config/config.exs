import Mix.Config

config :dwight, ecto_repos: [Dwight.Repo]

config :dwight, Dwight.Repo,
  database: "dwight_#{Mix.env()}",
  hostname: "localhost",
  username: "postgres",
  password: "postgres"

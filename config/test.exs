use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# config :apartman, Apartman.Repo,
#   username: "postgres",
#   password: "postgres",
#   database: "apartman_test#{System.get_env("MIX_TEST_PARTITION")}",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox

# not using this, for simplicity
# import_config "dev.secret.exs"

config :apartman, ecto_repos: [Apartman.Repo]

# Seraph config
config :apartman, Apartman.Repo,
  hostname: "localhost",
  basic_auth: [username: "neo4j", password: "apartman"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1

# Bolt.Sips config
config :bolt_sips, Bolt,
  url: "bolt://localhost:7687",
  basic_auth: [username: "neo4j", password: "apartman"],
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :apartman, ApartmanWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Reduce the number of rounds to speedup during test
config :pbkdf2_elixir, :rounds, 1

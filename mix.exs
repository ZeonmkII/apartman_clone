defmodule Apartman.MixProject do
  use Mix.Project

  def project do
    [
      app: :apartman,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Apartman.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto, "~> 3.4"},
      {:ecto_sql, "~> 3.4"},
      {:bolt_sips, "~> 2.0"},
      {:seraph, "~> 0.1.0"},
      {:phoenix_live_view, "~> 0.13.2"},
      {:floki, "~> 0.26.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.2.5"},
      {:telemetry_metrics, "~> 0.5.0"},
      {:telemetry_poller, "~> 0.5.0"},
      {:gettext, "~> 0.18.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.2"},
      {:pbkdf2_elixir, "~> 1.2"},
      {:tzdata, "~> 1.0"},
      {:faker, "~> 0.13.0"},
      {:benchee, "~> 1.0"},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_ecto, "~> 0.1.3"},
      {:inflex, "~> 2.0.0"},
      {:timex, "~> 3.5"},
      {:elixlsx, "~> 0.4.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
      seed: ["run priv/repo/seeds.exs"],
      test: ["test"]
    ]
  end
end

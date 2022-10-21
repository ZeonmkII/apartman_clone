defmodule Apartman.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Apartman.Repo,
      # Start Bolt.Sips driver in direct mode
      {Bolt.Sips, Application.get_env(:bolt_sips, Bolt)},
      # Start the Telemetry supervisor
      ApartmanWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Apartman.PubSub},
      # Start the Endpoint (http/https)
      ApartmanWeb.Endpoint
      # Start a worker by calling: Apartman.Worker.start_link(arg)
      # {Apartman.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apartman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApartmanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

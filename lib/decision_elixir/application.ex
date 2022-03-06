defmodule DecisionElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DecisionElixir.Repo,
      # Start the Telemetry supervisor
      DecisionElixirWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DecisionElixir.PubSub},
      # Start the Endpoint (http/https)
      DecisionElixirWeb.Endpoint
      # Start a worker by calling: DecisionElixir.Worker.start_link(arg)
      # {DecisionElixir.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DecisionElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DecisionElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

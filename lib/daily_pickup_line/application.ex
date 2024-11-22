defmodule DailyPickupLine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DailyPickupLineWeb.Telemetry,
      DailyPickupLine.Repo,
      {DNSCluster, query: Application.get_env(:daily_pickup_line, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DailyPickupLine.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DailyPickupLine.Finch},
      # Start a worker by calling: DailyPickupLine.Worker.start_link(arg)
      # {DailyPickupLine.Worker, arg},
      # Start to serve requests, typically the last entry
      DailyPickupLineWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DailyPickupLine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DailyPickupLineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

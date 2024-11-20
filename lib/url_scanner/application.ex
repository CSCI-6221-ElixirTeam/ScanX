defmodule UrlScanner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UrlScannerWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:url_scanner, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UrlScanner.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UrlScanner.Finch},
      # Start a worker by calling: UrlScanner.Worker.start_link(arg)
      # {UrlScanner.Worker, arg},
      # Start to serve requests, typically the last entry
      UrlScannerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UrlScanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UrlScannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule UrlScannerWeb.Router do
  use UrlScannerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {UrlScannerWeb.Layouts, :root}
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UrlScannerWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/scan_url", PageController, :scan_url
    get "/url_analysis", PageController, :url_analysis
    post "/scan_file", PageController, :scan_file
    post "/scan_ip", PageController, :scan_ip       # Added IP routes
    get "/ip_analysis", PageController, :ip_analysis
  end

  if Application.compile_env(:url_scanner, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: UrlScannerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
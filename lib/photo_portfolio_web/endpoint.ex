defmodule PhotoPortfolioWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :photo_portfolio

  @session_options [
    store: :cookie,
    key: "_photo_portfolio_key",
    signing_salt: "your_signing_salt"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve uploaded files from "priv/static/uploads"
  plug Plug.Static,
    at: "/uploads",
    from: "priv/static/uploads",
    gzip: false

  plug Plug.Static,
    at: "/",
    from: :photo_portfolio,
    gzip: false,
    only: PhotoPortfolioWeb.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :photo_portfolio
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library(),
    length: 100_000_000  # Sets max upload size to ~100MB

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PhotoPortfolioWeb.Router
end

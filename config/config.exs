import Config

# Add this line to configure Ecto repositories
config :photo_portfolio, ecto_repos: [PhotoPortfolio.Repo]

config :photo_portfolio, PhotoPortfolio.Repo,
  username: "postgres",
  password: "postgres",
  database: "photo_portfolio_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :photo_portfolio, PhotoPortfolioWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: PhotoPortfolioWeb.ErrorHTML, json: PhotoPortfolioWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PhotoPortfolio.PubSub,
  live_view: [signing_salt: "your_signing_salt"]

# Configure logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :file, :line],
  level: :debug

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"

# Configure esbuild
config :esbuild,
  version: "0.19.2",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

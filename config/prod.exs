# Here are the contents for the file: /photo_portfolio/photo_portfolio/config/prod.exs

import Config

config :photo_portfolio, PhotoPortfolio.Repo,
  username: "prod_user",
  password: "prod_password",
  database: "photo_portfolio_prod",
  hostname: "prod_db_host",
  pool_size: 15

config :photo_portfolio, PhotoPortfolioWeb.Endpoint,
  http: [port: 4000],
  secret_key_base: "your_secret_key_base",
  server: true

config :logger, level: :info

config :phoenix, :serve_endpoints, true
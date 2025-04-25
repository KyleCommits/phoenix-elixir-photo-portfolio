import Config

config :photo_portfolio, PhotoPortfolio.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "photo_portfolio_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

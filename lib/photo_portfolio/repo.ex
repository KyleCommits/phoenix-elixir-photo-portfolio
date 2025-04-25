defmodule PhotoPortfolio.Repo do
  use Ecto.Repo,
    otp_app: :photo_portfolio,
    adapter: Ecto.Adapters.Postgres

end

defmodule PhotoPortfolioWeb.PageController do
  use PhotoPortfolioWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end

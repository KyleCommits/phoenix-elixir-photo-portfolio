defmodule PhotoPortfolioWeb.Router do
  use PhotoPortfolioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhotoPortfolioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhotoPortfolioWeb do
    pipe_through :browser

    get "/", PhotoController, :index
    resources "/photos", PhotoController
  end

  # Configure other endpoints...
end

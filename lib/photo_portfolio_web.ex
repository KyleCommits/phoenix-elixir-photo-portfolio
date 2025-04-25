defmodule PhotoPortfolioWeb do
  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: PhotoPortfolioWeb.Layouts]

      import Plug.Conn
      import PhotoPortfolioWeb.Gettext

      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      import Phoenix.HTML
      import PhotoPortfolioWeb.CoreComponents
      import PhotoPortfolioWeb.Gettext
      alias Phoenix.LiveView.JS
      unquote(verified_routes())
    end
  end

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: PhotoPortfolioWeb.Endpoint,
        router: PhotoPortfolioWeb.Router,
        statics: PhotoPortfolioWeb.static_paths()
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)
end

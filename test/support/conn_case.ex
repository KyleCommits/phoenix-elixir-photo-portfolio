defmodule PhotoPortfolio.Test.Support.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias PhotoPortfolio.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import PhotoPortfolioWeb.ConnCase
      import Plug.Test

      @endpoint PhotoPortfolioWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
defmodule PhotoPortfolioWeb.PageControllerTest do
  use PhotoPortfolioWeb.ConnCase

  describe "index" do
    test "renders the index page", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Welcome to the Photo Portfolio"
    end
  end
end
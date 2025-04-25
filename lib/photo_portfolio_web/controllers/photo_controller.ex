defmodule PhotoPortfolioWeb.PhotoController do
  use PhotoPortfolioWeb, :controller

  alias PhotoPortfolio.Photos
  alias PhotoPortfolio.Photos.Photo

  def index(conn, _params) do
    photos = Photos.list_photos()
    render(conn, :index, photos: photos)
  end

  def new(conn, _params) do
    changeset = Photos.change_photo(%Photo{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"photo" => photo_params}) do
    case Photos.create_photo(photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo created successfully.")
        |> redirect(to: ~p"/photos/#{photo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    render(conn, :show, photo: photo)
  end

  def delete(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    {:ok, _photo} = Photos.delete_photo(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: ~p"/")
  end
end

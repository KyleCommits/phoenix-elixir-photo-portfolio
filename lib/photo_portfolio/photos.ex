defmodule PhotoPortfolio.Photos do
  import Ecto.Query
  alias PhotoPortfolio.Repo
  alias PhotoPortfolio.Photos.Photo

  def list_photos do
    Repo.all(Photo)
  end

  def get_photo!(id), do: Repo.get!(Photo, id)

  def create_photo(attrs \\ %{}) do
    %Photo{}
    |> Photo.changeset(attrs)
    |> Repo.insert()
  end

  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  def delete_photo(%Photo{} = photo) do
    Repo.delete(photo)
  end

  def change_photo(%Photo{} = photo, attrs \\ %{}) do
    Photo.changeset(photo, attrs)
  end
end

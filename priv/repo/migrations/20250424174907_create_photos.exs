defmodule PhotoPortfolio.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :title, :string
      add :description, :text
      add :image, :string  # Changed from image_url to image

      timestamps()
    end
  end
end

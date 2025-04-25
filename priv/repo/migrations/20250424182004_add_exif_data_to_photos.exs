defmodule PhotoPortfolio.Repo.Migrations.AddExifDataToPhotos do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :camera_make, :string
      add :camera_model, :string
      add :f_number, :string
      add :exposure_time, :string
      add :iso, :string
      add :flash, :string
      add :focal_length, :string
      add :resolution, :string
      add :bit_depth, :string
    end
  end
end

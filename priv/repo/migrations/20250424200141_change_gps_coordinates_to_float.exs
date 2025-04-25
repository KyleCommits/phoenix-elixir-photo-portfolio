defmodule PhotoPortfolio.Repo.Migrations.ChangeGpsCoordinatesToFloat do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      modify :latitude, :float
      modify :longitude, :float
    end
  end
end

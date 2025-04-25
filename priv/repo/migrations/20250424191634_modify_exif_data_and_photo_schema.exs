defmodule PhotoPortfolio.Repo.Migrations.UpdatePhotosSchema do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      remove :description
      modify :title, :string, null: true
      add :latitude, :float
      add :longitude, :float
    end
  end
end

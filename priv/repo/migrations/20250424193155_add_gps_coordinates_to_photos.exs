defmodule PhotoPortfolio.Repo.Migrations.AddGpsCoordinatesToPhotos do
  use Ecto.Migration

  def change do
    # First check if columns exist
    unless column_exists?(:photos, :latitude) do
      alter table(:photos) do
        add :latitude, :decimal, precision: 10, scale: 6
        add :longitude, :decimal, precision: 10, scale: 6
      end
    end
  end

  defp column_exists?(table, column) do
    query = """
    SELECT 1
    FROM information_schema.columns
    WHERE table_name = '#{table}'
    AND column_name = '#{column}'
    """
    case repo().query(query) do
      {:ok, %{num_rows: 1}} -> true
      _ -> false
    end
  end
end

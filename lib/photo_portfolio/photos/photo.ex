defmodule PhotoPortfolio.Photos.Photo do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  schema "photos" do
    field :title, :string
    field :image, :string
    field :image_upload, :any, virtual: true

    # EXIF data fields
    field :camera_make, :string
    field :camera_model, :string
    field :f_number, :string
    field :exposure_time, :string
    field :iso, :string
    field :flash, :string
    field :focal_length, :string
    field :resolution, :string
    field :bit_depth, :string
    field :latitude, :float
    field :longitude, :float
    timestamps()
  end

  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:title, :image, :image_upload, :camera_make, :camera_model,
                   :f_number, :exposure_time, :iso, :flash, :focal_length,
                   :resolution, :bit_depth, :latitude, :longitude])
    # Notice we're not using validate_required for title
    |> handle_image_upload()
  end

  defp handle_image_upload(changeset) do
    case get_change(changeset, :image_upload) do
      nil ->
        Logger.info("No image upload found")
        changeset
      upload ->
        Logger.info("Processing upload: #{upload.filename}")

        # Extract EXIF data
        exif_data = case Exexif.exif_from_jpeg_file(upload.path) do
          {:ok, data} ->
            Logger.info("EXIF data extracted successfully")
            data
          {:error, reason} ->
            Logger.error("Failed to extract EXIF data: #{inspect(reason)}")
            %{ }
          _ ->
            Logger.error("Unexpected error extracting EXIF data")
            %{ }
        end

        # Use filename as default title if blank
        default_title = Path.rootname(upload.filename)
        extension = Path.extname(upload.filename)
        filename = "#{Ecto.UUID.generate()}#{extension}"
        destination = Path.join("priv/static/uploads", filename)

        File.mkdir_p!(Path.dirname(destination))
        File.cp!(upload.path, destination)

        # Access nested EXIF data with defaults
        exif = exif_data[:exif] || %{ }
        gps = exif_data[:gps]

        changeset
        |> put_change_if_empty(:title, default_title)
        |> put_change(:image, "/uploads/#{filename}")
        |> put_change(:camera_make, to_string(exif_data[:make] || "Unknown"))
        |> put_change(:camera_model, to_string(exif_data[:model] || "Unknown"))
        |> put_change(:f_number, format_number(exif[:f_number]))
        |> put_change(:exposure_time, format_exposure(exif[:exposure_time]))
        |> put_change(:iso, to_string(exif[:iso_speed_ratings] || "Unknown"))
        |> put_change(:flash, format_flash(exif[:flash]))
        |> put_change(:focal_length, format_focal_length(exif[:focal_length]))
        |> put_change(:resolution, format_resolution(exif_data[:x_resolution]))
        |> put_change(:bit_depth, "24 bit")
        |> maybe_put_gps_coordinates(gps)
    end
  end

  # Handle GPS coordinates with nil check
  defp maybe_put_gps_coordinates(changeset, nil), do: changeset
  defp maybe_put_gps_coordinates(changeset, gps) do
    case {gps.gps_latitude, gps.gps_longitude, gps.gps_latitude_ref, gps.gps_longitude_ref} do
      {[d,m,s], [d2,m2,s2], ref1, ref2} when not is_nil(ref1) and not is_nil(ref2) ->
        lat = convert_gps_coordinate([d,m,s], ref1)
        lon = convert_gps_coordinate([d2,m2,s2], ref2)
        Logger.info("Adding GPS coordinates: #{lat}, #{lon}")
        changeset
        |> put_change(:latitude, lat)
        |> put_change(:longitude, lon)
      _ ->
        Logger.info("Invalid or missing GPS data")
        changeset
    end
  end

  # Helper functions with default values
  defp format_number(nil), do: "Unknown"
  defp format_number(num) when is_number(num), do: "f/#{:erlang.float_to_binary(num, decimals: 1)}"
  defp format_number(value), do: to_string(value)

  defp format_exposure(nil), do: "Unknown"
  defp format_exposure(time) when is_number(time), do: "#{:erlang.float_to_binary(time, decimals: 3)} sec"
  defp format_exposure(value), do: to_string(value)

  defp format_flash(nil), do: "Unknown"
  defp format_flash(flash), do: to_string(flash)

  defp format_focal_length(nil), do: "Unknown"
  defp format_focal_length(length) when is_number(length), do: "#{:erlang.float_to_binary(length, decimals: 1)}mm"
  defp format_focal_length(value), do: to_string(value)

  defp format_resolution(nil), do: "Unknown"
  defp format_resolution(res), do: "#{res} dpi"

  defp convert_gps_coordinate([degrees, minutes, seconds], ref) do
    decimal = degrees + (minutes / 60.0) + (seconds / 3600.0)
    case ref do
      "S" -> -decimal
      "W" -> -decimal
      _ -> decimal
    end
  end
  defp convert_gps_coordinate(_, _), do: nil

  # Helper function to set value only if current value is empty
  defp put_change_if_empty(changeset, field, value) do
    if get_change(changeset, field) in [nil, ""] do
      put_change(changeset, field, value)
    else
      changeset
    end
  end
end

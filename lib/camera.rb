require "bundler/setup"

require "faraday"
require "json"
require "byebug"
require_relative "asset"

class Camera
  def details
    fetch_camera_details
  end

  def assets
    assets_index = fetch_assets_index

    return [] unless assets_index

    directories = assets_index["dirs"]

    directories.flat_map do |directory|
      directory_name = directory["name"]
      asset_names = directory["files"]

      asset_names.map do |asset_name|
        Asset.new(
          remote_location: directory_name,
          name: asset_name,
        )
      end
    end
  end

  private

  CAMERA_URL = "http://192.168.0.1"

  def fetch_camera_details
    connection = Faraday.new(url: CAMERA_URL)

    response = connection.get do |request|
      request.url "v1/props"
      request.headers["Accept-Encoding"] = "gzip"
    end

    JSON.parse(response.body) if response.status == 200
  end


  def fetch_assets_index
    connection = Faraday.new(url: CAMERA_URL)

    response = connection.get do |request|
      request.url "v1/photos"
      request.params["storage"] = "in"
      request.headers["Accept-Encoding"] = "gzip"
    end

    JSON.parse(response.body) if response.status == 200
  end

end

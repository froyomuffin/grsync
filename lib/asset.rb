require "bundler/setup"

require "faraday"
require "json"

class Asset
  attr_reader :remote_location, :name

  def initialize(remote_location:, name:)
    @remote_location = remote_location
    @name = name
  end

  def details
    fetch_asset_details
  end

  def preview
    fetch_asset(preview: true)
  end

  def data
    fetch_asset
  end

  private


  CAMERA_URL = "http://192.168.0.1"


  def fetch_asset_details
    connection = Faraday.new(url: CAMERA_URL)

    response = connection.get do |request|
      request.url "v1/photos/#{@remote_location}/#{@name}/info"
      request.params["storage"] = "in"
      request.headers["Accept-Encoding"] = "gzip"
    end

    JSON.parse(response.body, symbolize_names: true) if response.status == 200
  end

  def fetch_asset(preview: false)
    connection = Faraday.new(url: CAMERA_URL)

    response = connection.get do |request|
      request.url "v1/photos/#{@remote_location}/#{@name}"
      request.params["size"] = "view" if preview
      request.params["storage"] = "in"
      request.headers["Accept-Encoding"] = "gzip"
    end

    {
      content_type: response.headers["content-type"],
      data: response.body
    } if response.status == 200
  end
end

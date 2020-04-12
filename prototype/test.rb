require "bundler/setup"

require "byebug"
require "faraday"
require "pp"
require "rake"
require "json"

puts "Starting"

CAMERA_URL = "http://192.168.0.1"
ANDROID_SPOOF_USER_AGENT = "Dalvik/2.1.0 (Linux; U; Android 9; Pixel 3 Build/PQ2A.190405.003)"
CONTENT_TYPE_TO_EXTENSION = {
  "image/jpeg" => "jpg",
  "image/x-adobe-dng" => "dng",
}

def fetch_camera_details
  connection = Faraday.new(url: CAMERA_URL)

  response = connection.get do |request|
    request.url "v1/props"
    request.headers["Accept-Encoding"] = "gzip"
  end

  JSON.parse(response.body) if response.status == 200
end

def fetch_asset_index
  connection = Faraday.new(url: CAMERA_URL)

  response = connection.get do |request|
    request.url "v1/photos"
    request.params["storage"] = "in"
    request.headers["Accept-Encoding"] = "gzip"
  end

  JSON.parse(response.body) if response.status == 200
end

def fetch_asset_details(asset_directory:, asset_name:)
  connection = Faraday.new(url: CAMERA_URL)

  response = connection.get do |request|
    request.url "v1/photos/#{asset_directory}/#{asset_name}/info"
    request.params["storage"] = "in"
    request.headers["Accept-Encoding"] = "gzip"
  end

  JSON.parse(response.body) if response.status == 200
end

def fetch_asset_preview(asset_directory:, asset_name:)
  connection = Faraday.new(url: CAMERA_URL)

  response = connection.get do |request|
    request.url "v1/photos/#{asset_directory}/#{asset_name}"
    request.params["size"] = "view"
    request.params["storage"] = "in"
    request.headers["Accept-Encoding"] = "gzip"
  end

  content_type = response.headers["content-type"]
  extension = CONTENT_TYPE_TO_EXTENSION[content_type]

  File.write(asset_name.ext(extension), response.body) if response.status == 200
end

def fetch_asset(asset_directory:, asset_name:)
  connection = Faraday.new(url: CAMERA_URL)

  response = connection.get do |request|
    request.url "v1/photos/#{asset_directory}/#{asset_name}"
    request.params["storage"] = "in"
    request.headers["Accept-Encoding"] = "gzip"
  end

  content_type = response.headers["content-type"]
  extension = CONTENT_TYPE_TO_EXTENSION[content_type]

  File.write(asset_name.ext(extension), response.body) if response.status == 200
end


pp fetch_camera_details
pp fetch_asset_index
pp fetch_asset_details(asset_directory: "100RICOH", asset_name: "_R000527.DNG")
fetch_asset_preview(asset_directory: "100RICOH", asset_name: "_R000527.DNG")
fetch_asset(asset_directory: "100RICOH", asset_name: "_R000527.DNG")

puts "Done"

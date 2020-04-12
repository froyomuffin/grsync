require_relative "test_helper"

class CameraTest < Minitest::Test
  include TestHelper

  describe "Camera" do
    before do
      @camera = Camera.new
    end

    describe "details" do
      it "returns camera details" do
        stub = JSON.parse(File.read("test/stubs/camera/details.json"))

        stub_request(:get, "http://192.168.0.1/v1/props")
          .with(
            headers: { "Accept-Encoding" => "gzip" },
          )
          .to_return(
            headers: stub["headers"],
            body: stub["body"].to_json,
          )

          assert_equal stub["body"], @camera.details
      end

      it "returns nil when there's a server issue" do
        stub_request(:get, "http://192.168.0.1/v1/props")
          .with(
            headers: { "Accept-Encoding" => "gzip" },
          )
          .to_return(
            status: [500, "Internal Server Error"],
          )

          assert_nil @camera.details
      end
    end

    describe "assets" do
      it "returns an array of properly initialized assets" do
        stub = JSON.parse(File.read("test/stubs/camera/assets.json"))

        stub_request(:get, "http://192.168.0.1/v1/photos")
          .with(
            headers: { "Accept-Encoding" => "gzip" },
            query: { "storage" => "in" },
          )
          .to_return(
            headers: stub["headers"],
            body: stub["body"].to_json,
          )

        expected = {
          "DIR1" => %w(FILE11.DNG FILE12.DNG FILE13.DNG),
          "DIR2" => %w(FILE21.DNG FILE22.DNG FILE23.DNG),
        }.flat_map do |location, assets|
          ([location] * assets.size).zip(assets)
        end

        result = @camera.assets.map do |asset|
          [asset.remote_location, asset.name]
        end

        assert_equal expected, result
      end

      it "returns an empty array when there's a server issue" do
        stub_request(:get, "http://192.168.0.1/v1/photos")
          .with(
            headers: { "Accept-Encoding" => "gzip" },
            query: { "storage" => "in" },
          )
          .to_return(
            status: [500, "Internal Server Error"],
          )

        assert_empty @camera.assets
      end
    end
  end
end

require_relative "test_helper"

class ContentTypeResolverTest < Minitest::Test
  include TestHelper

  describe "ContentTypeResolver", :resolve_extension do
    it "resolves 'image/jpeg to 'jpg'" do
      assert_equal "jpg", ContentTypeResolver.resolve_extension(content_type: "image/jpeg")
    end

    it "resolves a content-type that's not been defined explicitly" do
      assert_equal "surprise", ContentTypeResolver.resolve_extension(content_type: "potato/cabbage/surprise")
    end
  end
end


class ContentTypeResolver
  class << self
    CONTENT_TYPE_TO_EXTENSION = {
      "image/jpeg" => "jpg",
      "image/x-adobe-dng" => "dng",
    }

    def resolve_extension(content_type:)
      extension = CONTENT_TYPE_TO_EXTENSION[content_type]

      return extension if extension

      content_type.split("/").last
    end
  end
end


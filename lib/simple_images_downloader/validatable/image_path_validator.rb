# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class ImagePathValidator < Validator
      VALID_EXTENSIONS = %w[.png .jpg .gif .jpeg].freeze

      def validate(path)
        extension = File.extname(path)

        return if VALID_EXTENSIONS.include?(extension)

        raise Errors::MissingImageInPath, path
      end
    end
  end
end

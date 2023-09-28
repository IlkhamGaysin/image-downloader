# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class FileAccessibilityValidator < Validator
      def validate(path)
        return if File.readable?(path)

        raise Errors::PermissionsError, path
      end
    end
  end
end

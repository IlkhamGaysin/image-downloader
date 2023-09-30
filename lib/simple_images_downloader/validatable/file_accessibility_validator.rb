# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class FileAccessibilityValidator < Validator
      def validate(options)
        return if File.readable?(options[:path])

        raise Errors::PermissionsError, options[:path]
      end
    end
  end
end

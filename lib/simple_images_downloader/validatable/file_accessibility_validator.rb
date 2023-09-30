# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    # FileAccessibilityValidator class
    # Responsible for validating file accessibility
    #
    # @example
    #   SimpleImagesDownloader::FileAccessibilityValidator.new.validate({ path: './urls.txt' })
    #
    class FileAccessibilityValidator < Validator
      # @param options [Hash] hash with path to file
      # @raise [Errors::PermissionsError] if file is not readable
      def validate(options)
        return if File.readable?(options[:path])

        raise Errors::PermissionsError, options[:path]
      end
    end
  end
end

# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class FilePersistanceValidator < Validator
      def validate(options)
        return if File.exist?(options[:path])

        raise Errors::MissingFileError, options[:path]
      end
    end
  end
end

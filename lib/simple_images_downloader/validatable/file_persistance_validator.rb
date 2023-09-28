# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class FilePersistanceValidator < Validator
      def validate(path)
        return if File.exist?(path)

        raise Errors::MissingFileError, path
      end
    end
  end
end

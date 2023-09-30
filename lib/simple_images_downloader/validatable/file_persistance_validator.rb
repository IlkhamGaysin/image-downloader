# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    # FilePersistanceValidator class
    # Responsible for validating file persistance
    #
    # @example
    #   SimpleImagesDownloader::FilePersistanceValidator.new.validate({ path: './urls.txt' })
    #
    class FilePersistanceValidator < Validator
      # @param options [Hash] hash with path to file
      # @raise [Errors::MissingFileError] if file does not exist
      def validate(options)
        return if File.exist?(options[:path])

        raise Errors::MissingFileError, options[:path]
      end
    end
  end
end

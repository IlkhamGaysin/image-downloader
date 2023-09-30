# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    # DestinationValidator class
    # Responsible for validating destination path
    #
    # @example
    #   SimpleImagesDownloader::DestinationValidator.new.validate({ path: './images' })
    #
    class DestinationValidator < Validator
      # @param options [Hash] hash with path to destination directory
      # @raise [Errors::DestinationIsNotDirectory] if destination is not directory
      # @raise [Errors::DestinationIsNotWritable] if destination is not writable
      def validate(options)
        path = options[:path]

        raise Errors::DestinationIsNotDirectory, path unless File.directory?(path)
        raise Errors::DestinationIsNotWritable, path unless File.writable?(path)
      end
    end
  end
end

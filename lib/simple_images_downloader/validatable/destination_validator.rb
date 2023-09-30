# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class DestinationValidator < Validator
      def validate(options)
        path = options[:path]

        raise Errors::DestinationIsNotDirectory, path unless File.directory?(path)
        raise Errors::DestinationIsNotWritable, path unless File.writable?(path)
      end
    end
  end
end

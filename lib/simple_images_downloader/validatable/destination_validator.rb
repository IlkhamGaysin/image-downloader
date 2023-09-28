# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class DestinationValidator < Validator
      def validate(destination_dir)
        raise Errors::DestinationIsNotDirectory, destination_dir unless File.directory?(destination_dir)
        raise Errors::DestinationIsNotWritable, destination_dir unless File.writable?(destination_dir)
      end
    end
  end
end

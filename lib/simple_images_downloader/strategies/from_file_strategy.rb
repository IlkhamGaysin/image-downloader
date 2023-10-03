# frozen_string_literal: true

module SimpleImagesDownloader
  module Strategies
    # Strategy for downloading images from file
    # Opens file and reads line by line and downloads images
    #
    # @example
    #   SimpleImagesDownloader::Strategies::FromFileStrategy.new('path/to/file').process
    class FromFileStrategy < Strategy
      def initialize(path)
        super
        @path = path
      end

      def process
        source_file = SourceFile.new(@path)

        source_file.each_line do |line|
          uri = Line.new(line).uri
          Downloader.new(uri).download
        rescue Errors::BaseError => e
          puts e.message
          next
        end
      end
    end
  end
end

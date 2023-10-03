# frozen_string_literal: true

module SimpleImagesDownloader
  module Strategies
    # Strategy for downloading images from url
    # Downloads image from url
    #
    # @example
    #   SimpleImagesDownloader::Strategies::FromUrlStrategy.new('https://example.com/image.jpg').process
    class FromUrlStrategy < Strategy
      # @param url [String] url to image
      def initialize(url)
        super
        @url = url
      end

      def process
        uri = Line.new(@url).uri

        Downloader.new(uri).download
      end
    end
  end
end

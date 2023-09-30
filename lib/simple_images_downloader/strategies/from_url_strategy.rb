# frozen_string_literal: true

module SimpleImagesDownloader
  module Strategies
    class FromUrlStrategy < Strategy
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

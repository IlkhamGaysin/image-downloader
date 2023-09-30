# frozen_string_literal: true

module SimpleImagesDownloader
  class Line
    def initialize(string)
      @string = string
    end

    def uri
      URI.parse(@string)
    rescue URI::Error
      raise Errors::BadUrl, @string
    end
  end
end

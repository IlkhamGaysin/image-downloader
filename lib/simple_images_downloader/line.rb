# frozen_string_literal: true

module SimpleImagesDownloader
  # Line class
  # Responsible for parsing the string into URI object
  #
  # @example
  #   SimpleImagesDownloader::Line.new('https://example.com/image.jpg').uri
  #   # => #<URI::HTTPS https://example.com/image.jpg>
  #
  class Line
    def initialize(string)
      @string = string
    end

    # @return [URI] URI object
    # @raise [Errors::BadUrl] if string is not a valid URI
    # @see Errors::BadUrl
    #
    def uri
      URI.parse(@string)
    rescue URI::Error
      raise Errors::BadUrl, @string
    end
  end
end

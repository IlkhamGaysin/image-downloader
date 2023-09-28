# frozen_string_literal: true

module SimpleImagesDownloader
  class Line
    include Validatable

    def initialize(string, validators = [ImagePathValidator.new])
      @string     = string
      @validators = validators
    end

    def uri
      parsed_uri = URI.parse(@string)

      validate!(@string)

      parsed_uri
    rescue URI::Error
      raise Errors::BadUrl, @string
    end
  end
end

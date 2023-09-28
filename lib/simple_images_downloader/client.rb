# frozen_string_literal: true

module SimpleImagesDownloader
  class Client
    def initialize(options = Configuration::REQUEST_OPTIONS)
      @options = options
    end

    def open(uri)
      uri.open(@options)
    rescue OpenURI::HTTPRedirect
      raise Errors::RedirectError, uri
    rescue OpenURI::HTTPError
      raise Errors::ConnectionError, uri
    end
  end
end

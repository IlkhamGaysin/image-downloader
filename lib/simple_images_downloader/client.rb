# frozen_string_literal: true

module SimpleImagesDownloader
  # add documentation to this class using YARD

  # Client class
  # Responsible for opening the URI and handling errors
  #
  # @example
  #   SimpleImagesDownloader::Client.new.open(uri)
  #
  class Client
    def initialize(options = Configuration::REQUEST_OPTIONS)
      @options = options
    end

    # @param uri [URI] URI object
    # @return [StringIO] StringIO object
    def open(uri)
      uri.open(@options)
    rescue OpenURI::HTTPRedirect
      raise Errors::RedirectError, uri
    rescue OpenURI::HTTPError
      raise Errors::ConnectionError, uri
    end
  end
end

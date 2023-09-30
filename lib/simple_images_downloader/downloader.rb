# frozen_string_literal: true

module SimpleImagesDownloader
  # Downloader class
  # Responsible for downloading images from URI and placing them to the destination folder
  # allows to use custom client and validators for downloading
  #
  # @example
  #   SimpleImagesDownloader::Downloader.new(uri).download
  #
  class Downloader
    include Validatable

    # @param uri [URI] URI object from which image will be downloaded
    # @param client [Client] Client object for opening the URI. Default: Client.new
    # @param validators [Array] array of validators for validating the response. Default: [MimeTypeValidator.new]
    def initialize(uri, client = Client.new, validators = [MimeTypeValidator.new])
      @uri        = uri
      @client     = client
      @validators = validators
    end

    # Downloads image from URI and places it to the destination folder
    #
    # @raise [Errors::EmptyResponse] if response is empty
    # @raise [Errors::BadMimeType] if response is not an image
    # @see Errors module
    # @see MimeTypeValidator
    def download
      puts "Downloading #{@uri}"

      io = @client.open(@uri)

      raise Errors::EmptyResponse, @uri if io.nil?

      validate!({ path: @uri.to_s, io: io })

      tempfile = StringioToTempfile.convert(io)

      Dispenser.new(tempfile, @uri.path).place

      puts 'Downloading is finished'
    ensure
      io&.close
      tempfile&.close
    end
  end
end

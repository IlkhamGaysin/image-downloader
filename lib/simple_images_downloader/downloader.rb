# frozen_string_literal: true

module SimpleImagesDownloader
  class Downloader
    include Validatable

    def initialize(uri, client = Client.new, validators = [MimeTypeValidator.new])
      @uri        = uri
      @client     = client
      @validators = validators
    end

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

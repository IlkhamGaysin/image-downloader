# frozen_string_literal: true

module SimpleImagesDownloader
  class Downloader
    def initialize(uri)
      @uri = uri
    end

    def download
      puts "Downloading #{@uri}"

      io = Client.new.open(@uri)

      downloaded_file = StringioToTempfile.convert(io) unless io.nil?

      Dispenser.new(downloaded_file, @uri.path).place

      puts 'Downloading is finished'
    ensure
      downloaded_file&.close
    end
  end
end

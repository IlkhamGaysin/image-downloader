# frozen_string_literal: true

module SimpleImagesDownloader
  # Runner class
  # Responsible for invoking interface to download images from file
  #
  # @example
  #   SimpleImagesDownloader::Runner.invoke('./urls.txt')
  #
  class Runner
    # Allows to invoke interface to download images from file
    def self.invoke
      raise SimpleImagesDownloader::Errors::MissingFileArgumentError if ARGV.size.zero?

      SimpleImagesDownloader.from_file(ARGV.first)
    end
  end
end

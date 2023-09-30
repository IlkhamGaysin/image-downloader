# frozen_string_literal: true

module SimpleImagesDownloader
  # SourceFile class
  # Responsible for opening the file of URLs and validating it
  #
  # @example
  #   SimpleImagesDownloader::SourceFile.new('./urls.txt').each_line do |line|
  #     puts line
  #   end
  #
  class SourceFile
    include Validatable

    # @param path [String] path to file
    # @param validators [Array] array of validators
    def initialize(path, validators = [FilePersistanceValidator.new, FileAccessibilityValidator.new])
      @path       = path
      @validators = validators
    end

    # @yield [line] passes each line of file to block
    # @yieldparam line [String] line of file
    def each_line(&block)
      validate!({ path: @path })

      begin
        file.each(chomp: true, &block)
      ensure
        file.close
      end
    end

    private

    def file
      @file ||= File.open(@path, 'r')
    end
  end
end

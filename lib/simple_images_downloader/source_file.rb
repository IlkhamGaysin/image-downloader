# frozen_string_literal: true

module SimpleImagesDownloader
  class SourceFile
    include Validatable

    def initialize(path, validators = [FilePersistanceValidator.new, FileAccessibilityValidator.new])
      @path       = path
      @validators = validators
    end

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

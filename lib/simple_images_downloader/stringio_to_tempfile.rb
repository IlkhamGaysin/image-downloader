# frozen_string_literal: true

module SimpleImagesDownloader
  # StringIOToTempfile module
  # Responsible for converting StringIO to Tempfile
  #
  # @example
  #   SimpleImagesDownloader::StringioToTempfile.convert(stringio)
  #  # => #<Tempfile:0x00007f9b9c0b3a38>
  #
  module StringioToTempfile
    module_function

    # @param stringio [StringIO] StringIO object
    # @return [Tempfile] Tempfile object
    def convert(stringio)
      tempfile = Tempfile.new(binmode: true)

      IO.copy_stream(stringio, tempfile)

      OpenURI::Meta.init tempfile, stringio

      tempfile
    end
  end
end

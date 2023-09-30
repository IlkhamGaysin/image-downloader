# frozen_string_literal: true

module SimpleImagesDownloader
  module StringioToTempfile
    module_function

    def convert(stringio)
      tempfile = Tempfile.new(binmode: true)

      IO.copy_stream(stringio, tempfile)

      OpenURI::Meta.init tempfile, stringio

      tempfile
    end
  end
end

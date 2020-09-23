# frozen_string_literal: true

module ImageFetcher
  module Errors
    class BaseError < StandardError; end

    class MissingFileArgumentError < BaseError
      def initialize
        message = 'First arguments must be file'
        super(message)
      end
    end

    class MissingFileError < BaseError
      def initialize(path)
        message = "File under #{path} path is absent"
        super(message)
      end
    end

    class BadUrl < BaseError
      def initialize(url)
        message = "The is not valid URL #{url}"
        super(message)
      end
    end

    class MissingImageInPath < BaseError
      def initialize(path)
        message = "The path doesn't contain image #{path}"
        super(message)
      end
    end

    class RedirectError < BaseError
      def initialize(uri)
        message = "The url has a redirect #{uri}"
        super(message)
      end
    end

    class ConnectionError < BaseError
      def initialize(uri)
        message = "There was connection error during downloading file for #{uri}"
        super(message)
      end
    end

    class DestinationIsNotWritable < BaseError
      def initialize(path)
        message = "The destination is not writable move file manually at #{path}"
        super(message)
      end
    end
  end
end

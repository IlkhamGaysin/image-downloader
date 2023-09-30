# frozen_string_literal: true

module SimpleImagesDownloader
  # Errors module
  # Responsible for storing all errors
  #
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

    class BadMimeType < BaseError
      def initialize(path, mime_type)
        message = "The image with path: #{path} has wrong mime type #{mime_type}"
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

    class DestinationIsNotDirectory < BaseError
      def initialize(path)
        message = "The destination - #{path} is not directory"
        super(message)
      end
    end

    class PermissionsError < BaseError
      def initialize(path)
        message = "Couldn't read file #{path} due to permissions error"
        super(message)
      end
    end

    class EmptyResponse < BaseError
      def initialize(uri)
        message = "Nothing returned from request #{uri}"
        super(message)
      end
    end
  end
end

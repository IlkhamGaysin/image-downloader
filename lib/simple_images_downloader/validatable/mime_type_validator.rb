# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    # MimeTypeValidator class
    # Responsible for validating mime type of file
    #
    # @example
    #   SimpleImagesDownloader::MimeTypeValidator.new.validate({ path: './image.jpg', io: StringIO.new })
    #
    class MimeTypeValidator < Validator
      extend Forwardable

      def_delegator 'SimpleImagesDownloader::Configuration', :valid_mime_types, :valid_mime_types

      # Validates mime type of file. The mime types are taken from file Configuration
      #
      # @param options [Hash] hash with path to file and io object. Example: { path: './image.jpg', io: StringIO }
      # @raise [Errors::BadMimeType] if mime type is not valid
      # @see Configuration::DEFAULT_VALID_MIME_TYPES to see default valid mime types or add your own
      def validate(options)
        path = options[:path]
        io   = options[:io]

        mime_type = mime_type_of(io)

        return if SimpleImagesDownloader::Configuration.valid_mime_types.include?(mime_type)

        raise Errors::BadMimeType.new(path, mime_type)
      end

      private

      # Returns mime type of file. Uses UNIX file command
      #
      # @see https://github.com/shrinerb/shrine/blob/master/lib/shrine/plugins/determine_mime_type.rb#L94
      # @param io [IO] io object
      # @return [String] mime type of file
      def mime_type_of(io)
        Open3.popen3('file --mime-type --brief -') do |stdin, stdout, stderr, thread|
          copy_stream(from: io, to: stdin.binmode)

          io.rewind
          stdin.close

          status = thread.value

          validate_thread_status(status)
          $stderr.print(stderr.read)

          output = stdout.read.strip

          validate_command_output(output)

          output
        end
      end

      def copy_stream(from:, to:)
        IO.copy_stream(from, to)
      rescue Errno::EPIPE # rubocop:disable Lint/SuppressedException
      end

      def validate_thread_status(status)
        raise Errors::BaseError, "file command failed to spawn: #{stderr.read}" if status.nil?
        raise Errors::BaseError, "file command failed: #{stderr.read}" unless status.success?
      end

      def validate_command_output(output)
        raise Errors::BaseError, "file command failed: #{output}" if output.include?('cannot open')
      end
    end
  end
end

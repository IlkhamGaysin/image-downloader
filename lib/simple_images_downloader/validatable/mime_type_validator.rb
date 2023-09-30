# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class MimeTypeValidator < Validator
      extend Forwardable

      def_delegator 'SimpleImagesDownloader::Configuration', :valid_mime_types, :valid_mime_types

      def validate(options)
        path = options[:path]
        io   = options[:io]

        mime_type = mime_type_of(io)

        return if Configuration::DEFAULT_VALID_MIME_TYPES_MAP[mime_type]

        raise Errors::BadMimeType.new(path, mime_type)
      end

      private

      # Taken from Shrine https://github.com/shrinerb/shrine/blob/master/lib/shrine/plugins/determine_mime_type.rb#L94
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

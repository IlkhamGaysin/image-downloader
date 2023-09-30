# frozen_string_literal: true

module SimpleImagesDownloader
  # Dispenser class
  # Responsible for moving tempfile to destination directory
  #
  # @example
  #   SimpleImagesDownloader::Dispenser.new(tempfile, 'https://example.com/image.jpg').place
  #
  class Dispenser
    extend Forwardable
    include Validatable

    def_delegator 'SimpleImagesDownloader::Configuration', :destination, :destination_dir

    # @param source [Tempfile] Tempfile object
    # @param remote_path [String] original path of the image from input of SimpleImagesDownloader module
    # @param validators [Array] array of validators for validating the destination directory.
    # Default: [DestinationValidator.new]
    def initialize(source, remote_path, validators = [DestinationValidator.new])
      @source      = source
      @remote_path = remote_path
      @validators  = validators
    end

    # Moves tempfile to destination directory
    #
    # @raise [Errors::BadDestination] if destination directory is not valid
    # @see DestinationValidator
    def place
      validate!({ path: destination_dir })

      FileUtils.mv @source, target
    end

    def target
      @target ||= destination_dir + file_name
    end

    def file_name
      @file_name ||= File.basename(@source) + File.extname(@remote_path)
    end

    private :destination_dir, :target, :file_name
  end
end

# frozen_string_literal: true

module SimpleImagesDownloader
  # Configuration class
  # @example
  #   SimpleImagesDownloader::Configuration.configure do |config|
  #     config.destination = './images'
  #     config.valid_mime_types = ['image/jpeg', 'image/png']
  #   end
  #
  #   SimpleImagesDownloader::Configuration.destination
  #   # => './images'
  #
  #   SimpleImagesDownloader::Configuration.valid_mime_types
  #   # => ['image/jpeg', 'image/png']
  #
  class Configuration
    include Singleton

    ACCESSORS = %i[
      destination
      valid_mime_types
    ].freeze

    REQUEST_OPTIONS = {
      'User-Agent' => "SimpleImagesDownloader/#{SimpleImagesDownloader::VERSION}",
      redirect: false,
      open_timeout: 30,
      read_timeout: 30
    }.freeze

    # https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Image_types#common_image_file_types
    DEFAULT_VALID_MIME_TYPES_MAP = {
      'image/avif' => true,
      'image/gif' => true,
      'image/apng' => true,
      'image/jpg' => true,
      'image/jpeg' => true,
      'image/png' => true,
      'image/svg+xml' => true,
      'image/webp' => true
    }.freeze

    DEFAULT_DESTINATION = './'

    attr_accessor(*ACCESSORS)

    def initialize
      @destination = DEFAULT_DESTINATION
      @valid_mime_types = DEFAULT_VALID_MIME_TYPES_MAP.keys
    end

    # Allows to set valid_mime_types to check against allowed mime types
    #
    # @param value [Array] Array of valid mime types followed by
    # RFC 1341 - MIME (Multipurpose Internet Mail Extensions) format
    # @raise [BaseError] if value is not an Array
    #
    def valid_mime_types=(value)
      raise BaseError, 'valid_mime_types must be an array' unless value.is_a?(Array)

      @valid_mime_types = value
    end

    #### Configurable options
    #
    # destination: String, default: './', description: 'Destination folder to put downloaded images'
    # valid_mime_types: Array,
    # default: [
    #  'image/avif', 'image/gif', 'image/apng', 'image/jpg',
    #  'image/jpeg', 'image/png', 'image/svg+xml', 'image/webp'
    # ], description: 'Valid mime types to download'
    #
    # @yield [config] Yields the Configuration object to the block
    #
    def self.configure
      yield instance
    end

    # rubocop:disable Style/OptionalBooleanParameter
    def self.respond_to_missing?(method, include_private = false)
      accessor?(method) || super
    end
    # rubocop:enable Style/OptionalBooleanParameter

    def self.method_missing(method, *args)
      super unless accessor?(method.to_s.gsub(/=$/, '').to_sym)
      instance.public_send(method, *args)
    end

    def self.accessor?(method)
      ACCESSORS.include?(method)
    end
  end
end

# frozen_string_literal: true

module SimpleImagesDownloader
  class Dispenser
    extend Forwardable
    include Validatable

    def_delegator 'SimpleImagesDownloader::Configuration', :destination, :destination_dir

    def initialize(source, remote_path, validators = [DestinationValidator.new])
      @source      = source
      @remote_path = remote_path
      @validators  = validators
    end

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

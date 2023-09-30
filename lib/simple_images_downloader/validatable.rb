# frozen_string_literal: true

module SimpleImagesDownloader
  # Validatable module
  # Responsible for validating the object using array of validators
  #
  # @example
  #   class SourceFile
  #     include Validatable
  #
  #     def initialize(path, validators = [FilePersistanceValidator.new, FileAccessibilityValidator.new])
  #       @path       = path
  #       @validators = validators
  #     end
  #
  #     def each_line(&block)
  #       validate!({ path: @path })
  #       # ...
  #     end
  #   end
  module Validatable
    # @param value [Object] value to validate
    # @raise [Errors::<Particular>Error] if value is not valid
    def validate!(value)
      (@validators ||= []).each { |validator| validator.validate(value) }
    end
  end
end

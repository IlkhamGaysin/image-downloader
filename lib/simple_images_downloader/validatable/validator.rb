# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    # Validator class
    # Responsible for defining interface for validators
    class Validator
      # @abstract
      def validate(_value)
        raise NotImplementedError, 'must be implemented in subclass'
      end
    end
  end
end

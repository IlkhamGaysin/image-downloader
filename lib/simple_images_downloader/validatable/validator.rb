# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    class Validator
      def validate(_value)
        raise NotImplementedError, 'must be implemented in subclass'
      end
    end
  end
end

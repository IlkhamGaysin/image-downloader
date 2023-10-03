# frozen_string_literal: true

module SimpleImagesDownloader
  module Strategies
    # Base class for all strategies
    class Strategy
      def initialize(_)
      end

      # @abstract
      def process
        raise NotImplementedError, 'must be implemented in subclass'
      end
    end
  end
end

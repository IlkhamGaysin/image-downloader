# frozen_string_literal: true

module SimpleImagesDownloader
  module Strategies
    class Strategy
      def initialize(_)
      end

      def process
        raise NotImplementedError, 'must be implemented in subclass'
      end
    end
  end
end

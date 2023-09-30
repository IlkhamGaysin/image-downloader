# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleImagesDownloader::Strategies::Strategy do
  describe '#process' do
    it 'raises NotImplementedError' do
      expect do
        described_class.new(anything).process
      end.to raise_error(NotImplementedError, 'must be implemented in subclass')
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleImagesDownloader::Validatable::Validator do
  describe '#validate' do
    subject(:validate) { validator.validate(anything) }

    let(:validator) { described_class.new }

    it 'raises NotImplementedError' do
      expect { validate }.to raise_error(NotImplementedError, 'must be implemented in subclass')
    end
  end
end

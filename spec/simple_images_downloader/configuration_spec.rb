# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleImagesDownloader::Configuration do
  describe SimpleImagesDownloader::Configuration::REQUEST_OPTIONS do
    subject(:options) { described_class }

    let(:expected_value) do
      {
        'User-Agent' => "SimpleImagesDownloader/#{SimpleImagesDownloader::VERSION}",
        redirect: false,
        open_timeout: 30,
        read_timeout: 30
      }
    end

    it { is_expected.to eql(expected_value) }
  end

  describe SimpleImagesDownloader::Configuration::DEFAULT_VALID_MIME_TYPES do
    subject(:default_valid_extensions) { described_class }

    let(:expected_value) do
      [
        'image/avif',
        'image/gif',
        'image/apng',
        'image/jpg',
        'image/jpeg',
        'image/png',
        'image/svg+xml',
        'image/webp'
      ]
    end

    it { is_expected.to eq(expected_value) }
  end

  describe '.destination' do
    context 'when instance is mocked' do
      let(:destination) { './spec' }
      let(:instance) { instance_double(described_class, destination: destination) }

      before do
        allow(described_class).to receive(:instance).and_return(instance)
      end

      it 'returns destination' do
        expect(described_class.destination).to eql(destination)
      end
    end

    context 'when instance is not mocked' do
      it 'returns default destination' do
        expect(described_class.destination).to eql('./')
      end
    end
  end

  describe '.valid_mime_types' do
    it 'returns default valid mime types map' do
      expect(described_class.valid_mime_types).to eql(described_class::DEFAULT_VALID_MIME_TYPES)
    end

    context 'when non array is passed' do
      it 'raises BaseError error' do
        expect { described_class.valid_mime_types = 'string' }
          .to raise_error(SimpleImagesDownloader::Errors::BaseError)
      end
    end
  end

  describe '.other_method' do
    it 'raises NoMethodError error' do
      expect { described_class.other_method }.to raise_error(NoMethodError)
    end
  end

  describe '.destination=' do
    let(:destination) { './lib' }

    let(:instance) do
      fake = Class.new { attr_accessor :destination }
      fake.new
    end

    before do
      allow(described_class).to receive(:instance).and_return(instance)
    end

    it 'changes destination' do
      expect { described_class.destination = destination }
        .to change(described_class, :destination).from(nil).to(destination)
    end
  end

  describe '.respond_to_missing?' do
    context 'when called method is present in SimpleImagesDownloader::ACCESSORS' do
      it 'responds to method' do
        expect(described_class).to respond_to(:destination)
      end
    end

    context 'when called method is not present in SimpleImagesDownloader::ACCESSORS' do
      it 'does not respond to method' do
        expect(described_class).not_to respond_to(:other_method)
      end
    end
  end

  describe '.configure' do
    let(:instance) do
      fake = Class.new { attr_accessor :min_confidence }
      fake.new
    end

    before do
      allow(described_class).to receive(:instance).and_return(instance)
    end

    it 'yields with instance' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(instance)
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleImagesDownloader::Client do
  let(:uri) { URI('https://example.com') }
  let(:options) { { Key: 'Value' } }

  describe '#initialize' do
    it 'sets options from Configuration::REQUEST_OPTIONS if not provided' do
      client = described_class.new
      expect(client.instance_variable_get(:@options))
        .to eq(SimpleImagesDownloader::Configuration::REQUEST_OPTIONS)
    end

    it 'sets options from provided options' do
      client = described_class.new(options)
      expect(client.instance_variable_get(:@options)).to eq(options)
    end
  end

  describe '#open' do
    subject(:open) { client.open(uri) }

    let(:client) { described_class.new }

    context 'when request raises OpenURI::HTTPRedirect' do
      let(:uri) { URI('http://google.com') }

      before do
        allow(uri).to receive(:open).and_raise(OpenURI::HTTPRedirect.new(nil, nil, nil))
      end

      it 'raises RedirectError' do
        expect { open }.to raise_error(SimpleImagesDownloader::Errors::RedirectError)
      end
    end

    context 'when request raises OpenURI::HTTPError' do
      let(:uri) { URI('http://example.com') }

      before do
        allow(uri).to receive(:open).and_raise(OpenURI::HTTPError.new(nil, nil))
      end

      it 'raises ConnectionError' do
        expect { open }.to raise_error(SimpleImagesDownloader::Errors::ConnectionError)
      end
    end

    context 'when request is successful' do
      before do
        allow(uri).to receive(:open)
          .with(SimpleImagesDownloader::Configuration::REQUEST_OPTIONS)
      end

      it 'calls open on URI with the correct arguments' do
        expect(uri).to receive(:open).with(client.instance_variable_get(:@options))
        client.open(uri)
      end
    end
  end
end

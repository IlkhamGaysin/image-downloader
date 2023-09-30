# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Errors do
  describe SimpleImagesDownloader::Errors::BaseError do
    it 'has custom message' do
      expect { raise described_class }.to raise_error(described_class)
    end
  end

  describe SimpleImagesDownloader::Errors::MissingFileArgumentError do
    it 'has custom message' do
      expect { raise described_class }.to raise_error(described_class, 'First arguments must be file')
    end
  end

  describe SimpleImagesDownloader::Errors::MissingFileError do
    let(:path) { '/test/test' }

    it 'has custom message' do
      expect { raise described_class, path }
        .to raise_error(described_class, "File under #{path} path is absent")
    end
  end

  describe SimpleImagesDownloader::Errors::BadUrl do
    let(:url) { Faker::Internet.url(path: '/test-image.png') }

    it 'has custom message' do
      expect { raise described_class, url }.to raise_error(described_class, "The is not valid URL #{url}")
    end
  end

  describe SimpleImagesDownloader::Errors::BadMimeType do
    let(:path) { '/test/test-image.text' }
    let(:mime_type) { 'text/plain' }

    it 'has custom message' do
      expect { raise described_class.new(path, mime_type) }
        .to raise_error(described_class, "The image with path: #{path} has wrong mime type #{mime_type}")
    end
  end

  describe SimpleImagesDownloader::Errors::RedirectError do
    let(:uri) { URI.parse(Faker::Internet.url(path: '/test-image.png')) }

    it 'has custom message' do
      expect { raise described_class, uri }.to raise_error(described_class, "The url has a redirect #{uri}")
    end
  end

  describe SimpleImagesDownloader::Errors::ConnectionError do
    let(:uri) { URI.parse(Faker::Internet.url(path: '/test-image.png')) }

    it 'has custom message' do
      expect { raise described_class, uri }
        .to raise_error(described_class, "There was connection error during downloading file for #{uri}")
    end
  end

  describe SimpleImagesDownloader::Errors::DestinationIsNotWritable do
    let(:path) { '/test/test-image.png' }

    it 'has custom message' do
      expect { raise described_class, path }
        .to raise_error(described_class, "The destination is not writable move file manually at #{path}")
    end
  end
end

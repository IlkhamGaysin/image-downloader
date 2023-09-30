# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Validatable::MimeTypeValidator do
  describe '#validate' do
    let(:validator) { described_class.new }

    context 'when mime type is valid' do
      let(:image_path) { File.join(SimpleImagesDownloader.root, 'spec', 'fixtures', 'image.png') }
      let(:options) { { path: image_path, io: File.open(image_path, 'rb') } }

      it 'does not raise an error' do
        expect { validator.validate(options) }.not_to raise_error
      end

      it 'returns image/png' do
        expect(validator).to receive(:mime_type_of).and_return('image/png').once

        validator.validate(options)
      end
    end

    context 'when custom mime type is passed to configuration' do
      let(:image_path) { File.join(SimpleImagesDownloader.root, 'spec', 'fixtures', 'text.txt') }
      let(:options) { { path: image_path, io: File.open(image_path, 'rb') } }

      before do
        SimpleImagesDownloader::Configuration.configure do |config|
          config.valid_mime_types = ['text/plain']
        end
      end

      after do
        SimpleImagesDownloader::Configuration.configure do |config|
          config.valid_mime_types = SimpleImagesDownloader::Configuration::DEFAULT_VALID_MIME_TYPES
        end
      end

      it 'does not raise an error' do
        expect { validator.validate(options) }.not_to raise_error
      end

      it 'returns text/plain' do
        expect(validator).to receive(:mime_type_of).and_return('text/plain').once

        validator.validate(options)
      end
    end

    context 'when mime type is invalid' do
      let(:text_file_path) { File.join(SimpleImagesDownloader.root, 'spec', 'fixtures', 'text.txt') }
      let(:options) { { path: text_file_path, io: File.open(text_file_path, 'rb') } }

      it 'raises a BadMimeType error' do
        expect do
          validator.validate(options)
        end.to raise_error(
          SimpleImagesDownloader::Errors::BadMimeType,
          "The image with path: #{text_file_path} has wrong mime type text\/plain"
        )
      end
    end
  end
end

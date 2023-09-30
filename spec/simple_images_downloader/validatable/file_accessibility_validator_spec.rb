# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Validatable::FileAccessibilityValidator do
  describe '#validate' do
    let(:validator) { described_class.new }

    it 'does not raise an error for a readable file' do
      file = Tempfile.new

      file.chmod(0o644)  # Make the file readable

      expect { validator.validate({ path: file.path }) }.not_to raise_error

      file.unlink
    end

    it 'raises a PermissionsError for an unreadable file' do
      file = Tempfile.new
      file.chmod(0o000)  # Make the file unreadable

      expect do
        validator.validate({ path: file.path })
      end.to raise_error(SimpleImagesDownloader::Errors::PermissionsError)

      file.unlink
    end
  end
end

# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Validatable::FilePersistanceValidator do
  describe '#validate' do
    subject(:validate) { described_class.new.validate(path) }

    let(:path) { './FilePersistanceValidator' }

    context 'when path is present' do
      context 'when files is persisted' do
        let(:file) { Tempfile.new('file-persistance-validator-png', fixtures_path) }
        let(:path) { file.path }

        after do
          file.close!
        end

        it { is_expected.to be_nil }
      end

      context 'when files is not persisted' do
        let(:file) { Tempfile.new('file-persistance-validator-.png', fixtures_path) }
        let(:path) { file.path }

        after do
          file.close!
        end

        it { is_expected.to be_nil }
      end
    end
  end
end

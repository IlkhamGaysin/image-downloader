# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Validatable::DestinationValidator do
  describe '#validate' do
    subject(:validate) { described_class.new.validate({ path: destination }) }

    context 'when destination_dir is not writable' do
      let(:destination) { '/usr' }

      before do
        allow(File).to receive(:writable?).with(destination).and_return(false)
      end

      it do
        expect do
          validate
        end.to raise_error(
          SimpleImagesDownloader::Errors::DestinationIsNotWritable,
          "The destination is not writable move file manually at #{destination}"
        )
      end
    end

    context 'when destination_dir is not directory' do
      let(:destination) { './Gemfile' }

      it do
        expect do
          validate
        end.to raise_error(
          SimpleImagesDownloader::Errors::DestinationIsNotDirectory,
          "The destination - #{destination} is not directory"
        )
      end
    end
  end
end

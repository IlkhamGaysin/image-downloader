# frozen_string_literal: true

require 'tempfile'

RSpec.describe SimpleImagesDownloader::Dispenser do
  describe '#place' do
    subject(:place) { dispenser.place }

    let(:source)      { Tempfile.new('dispenser-test-source.png', fixtures_path) }
    let(:remote_path) { fixtures_path('dispenser-test-moved.png') }
    let(:dispenser)   { described_class.new(source, remote_path) }

    after do
      source.close!
      FileUtils.remove_entry_secure(remote_path) if File.exist?(remote_path)
    end

    context 'when source and remote_path are right typed' do
      before do
        allow(dispenser).to receive(:target).and_return(remote_path)
      end

      it 'moves source file to destination' do
        expect(File).not_to be_exist(remote_path)

        place

        expect(File).to be_exist(remote_path)
      ensure
        source.close!
        FileUtils.remove_entry_secure(remote_path) if File.exist?(remote_path)
      end
    end

    context 'when destination_dir is not writable' do
      let(:destination) { '/usr' }

      before do
        allow(SimpleImagesDownloader::Configuration).to receive(:destination).and_return(destination)
        allow(File).to receive(:writable?).with(destination).and_return(false)
      end

      it do
        expect do
          place
        end.to raise_error(
          SimpleImagesDownloader::Errors::DestinationIsNotWritable,
          "The destination is not writable move file manually at #{destination}"
        )
      end
    end

    context 'when destination_dir is not directory' do
      let(:destination) { './Gemfile' }

      before do
        allow(SimpleImagesDownloader::Configuration).to receive(:destination).and_return(destination)
      end

      it do
        expect do
          place
        end.to raise_error(
          SimpleImagesDownloader::Errors::DestinationIsNotDirectory,
          "The destination - #{destination} is not directory"
        )
      end
    end
  end
end

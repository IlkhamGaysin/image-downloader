# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Runner do
  describe '.invoke' do
    context 'when ARGV has first argument' do
      let(:path) { 'file/path' }

      before do
        stub_const('ARGV', [path])
      end

      it do
        expect(SimpleImagesDownloader).to receive(:from_file).with(path).once

        described_class.invoke
      end
    end

    context "when ARGV doesn't have first argument" do
      before do
        allow(ARGV).to receive(:size).and_return(0)
      end

      it do
        expect do
          described_class.invoke
        end.to raise_error(
          SimpleImagesDownloader::Errors::MissingFileArgumentError,
          'First arguments must be file'
        )
      end
    end
  end
end

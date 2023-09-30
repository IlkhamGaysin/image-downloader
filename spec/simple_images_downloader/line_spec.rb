# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Line do
  describe '#uri' do
    subject(:uri) { described_class.new(string).uri }

    let(:string) { Faker::Placeholdit.image }

    context 'when string is not nil' do
      it 'returns instance of URI' do
        expect(uri).to eql(URI(string))
      end
    end

    context 'when string is nil' do
      let(:string) { nil }

      it do
        expect do
          uri
        end.to raise_error(
          SimpleImagesDownloader::Errors::BadUrl,
          'The is not valid URL '
        )
      end
    end
  end
end

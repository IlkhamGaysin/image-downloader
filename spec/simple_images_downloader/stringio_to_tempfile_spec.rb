# frozen_string_literal: true

require 'tempfile'

RSpec.describe SimpleImagesDownloader::StringioToTempfile do
  describe '.convert' do
    subject(:converted_file) { described_class.convert(stringio) }

    let(:content)  { "#{Faker::Placeholdit.image}\n#{Faker::Placeholdit.image}\n" }
    let(:stringio) { StringIO.new(content, binmode: true) }
    let(:uri)      { URI(Faker::Placeholdit.image(format: 'png')) }
    let(:metas)    { { 'content-type' => ['image/png'] } }

    before do
      allow(stringio).to receive(:status).and_return(%w[200 OK])
      allow(stringio).to receive(:base_uri).and_return(uri)
      allow(stringio).to receive(:metas).and_return(metas)
    end

    it 'returns a temfile' do
      expect(converted_file).to be_kind_of(Tempfile)
    ensure
      converted_file.close!
    end

    it 'copies content from stringio to tempfile' do
      converted_file.rewind

      expect(converted_file.read).to eql(content)
    ensure
      converted_file.close!
    end

    it 'adds meta information to tempfile from sringio' do
      expect(converted_file.metas).to match_array(metas)
    end
  end
end

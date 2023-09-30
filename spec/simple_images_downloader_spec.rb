# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader do
  it 'has a version number' do
    expect(SimpleImagesDownloader::VERSION).to eql('1.1.1')
  end

  describe '.root' do
    subject(:root) { described_class.root }

    it { is_expected.to eql(File.dirname(__dir__)) }
  end

  describe '.from_file' do
    subject(:from_file) { described_class.from_file(file.path) }

    let(:strategy) { instance_double('SimpleImagesDownloader::Strategies::FromFileStrategy') }
    let(:file) { Tempfile.new('test') }

    before do
      allow(SimpleImagesDownloader::Strategies::FromFileStrategy).to receive(:new).with(file.path).and_return(strategy)
      allow(strategy).to receive(:process)
    end

    it 'runs FromFileStrategy strategy' do
      expect(SimpleImagesDownloader::Strategies::FromFileStrategy).to receive(:new).with(file.path)
      expect(strategy).to receive(:process)

      from_file
    end
  end

  describe '.from_url' do
    subject(:from_url) { described_class.from_url(url) }

    let(:url) { Faker::Internet.url }
    let(:strategy) { instance_double('SimpleImagesDownloader::Strategies::FromUrlStrategy') }

    before do
      allow(SimpleImagesDownloader::Strategies::FromUrlStrategy).to receive(:new).with(url).and_return(strategy)
      allow(strategy).to receive(:process)
    end

    it 'runs FromUrlStrategy strategy' do
      expect(SimpleImagesDownloader::Strategies::FromUrlStrategy).to receive(:new).with(url)
      expect(strategy).to receive(:process)

      from_url
    end
  end
end

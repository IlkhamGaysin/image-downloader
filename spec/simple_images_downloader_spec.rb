# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader do
  it 'has a version number' do
    expect(SimpleImagesDownloader::VERSION).to eql('1.0.3')
  end

  describe '.root' do
    subject(:root) { described_class.root }

    it { is_expected.to eql(File.dirname(__dir__)) }
  end

  describe '.from_file', :vcr do
    subject(:from_file) { described_class.from_file(file.path) }

    let(:file)    { Tempfile.new(['image-fetcher-test-real-request', fixtures_path('image-fetcher/')]) }
    let(:line_1)  { "https://test-for-image-fetcher.s3.eu-central-1.amazonaws.com/7.5MB.jpg\n" }
    let(:line_2)  { "https://test-for-image-fetcher.s3.eu-central-1.amazonaws.com/less_than_10kb.png\n" }

    before do
      [line_1, line_2].each { |line| file.write(line) }
      file.close

      FileUtils.mkdir_p(fixtures_path('image-fetcher'))
      SimpleImagesDownloader::Configuration.destination = fixtures_path('image-fetcher/')
    end

    after do
      file.close!
      FileUtils.rm_rf(fixtures_path('image-fetcher/'))
    end

    it 'downloads images' do
      expect(fixtures_files('image-fetcher/*.*')).to be_empty

      from_file

      fixtures_files('image-fetcher/*.*').each do |path|
        expect(File).to be_exist(path)
      end
    end

    it 'keeps images consistency' do
      expect(fixtures_files('image-fetcher/*.*')).to be_empty

      from_file

      image_1 = File.open(fixtures_files('image-fetcher/*.png').first)
      image_2 = File.open(fixtures_files('image-fetcher/*.jpg').first)

      expect(image_1.size).to be(5795)
      expect(image_2.size).to be(7_471_971)
    end

    context 'when there is SimpleImagesDownloader::Errors::RedirectError raised for an yielded line' do
      let(:line_1) { "http://github.com\n" }

      it 'downloads image from url not contained redirect' do
        expect(fixtures_files('image-fetcher/*.*')).to be_empty

        from_file

        expect(fixtures_files('image-fetcher/*.*')).to contain_exactly(an_instance_of(String))

        image = File.open(fixtures_files('image-fetcher/*.png').first)

        expect(image.size).to be(5795)
      end
    end
  end

  describe '.from_url' do
    subject(:from_url) { described_class.from_url(url) }

    let(:url) { 'https://test-for-image-fetcher.s3.eu-central-1.amazonaws.com/7.5MB.jpg' }

    context 'when trere is request', :vcr do
      before do
        FileUtils.mkdir_p(fixtures_path('image-fetcher'))
        SimpleImagesDownloader::Configuration.destination = fixtures_path('image-fetcher/')
      end

      after do
        FileUtils.rm_rf(fixtures_path('image-fetcher/'))
      end

      it 'downloads image' do
        expect(fixtures_files('image-fetcher/*.*')).to be_empty

        from_url

        fixtures_files('image-fetcher/*.*').each do |path|
          expect(File).to be_exist(path)
        end
      end

      it 'downloads corresponding image from file' do
        expect(fixtures_files('image-fetcher/*.*')).to be_empty

        from_url

        image = File.open(fixtures_files('image-fetcher/*.jpg').first)

        expect(image.size).to be(7_471_971)
      end
    end

    context 'when trere is no request' do
      let(:uri)        { URI.parse(url) }
      let(:line)       { instance_double('SimpleImagesDownloader::Line') }
      let(:downloader) { instance_double('SimpleImagesDownloader::Downloader') }

      it do
        expect(SimpleImagesDownloader::Line).to receive(:new).with(url).and_return(line)
        expect(line).to receive(:uri).and_return(uri)
        expect(SimpleImagesDownloader::Downloader).to receive(:new).with(uri).and_return(downloader)
        expect(downloader).to receive(:download)

        from_url
      end
    end
  end
end

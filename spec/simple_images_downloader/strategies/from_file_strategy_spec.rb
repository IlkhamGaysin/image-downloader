# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleImagesDownloader::Strategies::FromFileStrategy do
  describe '#process', :vcr do
    subject(:process) { described_class.new(file.path).process }

    let(:file)    { Tempfile.new(['image-fetcher-test-real-request', fixtures_path('image-fetcher/')]) }
    let(:line_1)  { "https://simple-images-downloader.s3.eu-west-3.amazonaws.com/7.5MB.jpg\n" }
    let(:line_2)  { "https://simple-images-downloader.s3.eu-west-3.amazonaws.com/less_than_10kb.png\n" }

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

      process

      fixtures_files('image-fetcher/*.*').each do |path|
        expect(File).to be_exist(path)
      end
    end

    it 'keeps images consistency' do
      expect(fixtures_files('image-fetcher/*.*')).to be_empty

      process

      image_1 = File.open(fixtures_files('image-fetcher/*.png').first)
      image_2 = File.open(fixtures_files('image-fetcher/*.jpg').first)

      expect(image_1.size).to be(5795)
      expect(image_2.size).to be(7_471_971)
    end

    context 'when there is SimpleImagesDownloader::Errors::RedirectError raised for an yielded line' do
      let(:line_1) { "http://github.com\n" }

      it 'downloads image from url not contained redirect' do
        expect(fixtures_files('image-fetcher/*.*')).to be_empty

        process

        expect(fixtures_files('image-fetcher/*.*')).to contain_exactly(an_instance_of(String))

        image = File.open(fixtures_files('image-fetcher/*.png').first)

        expect(image.size).to be(5795)
      end
    end

    context 'when there is a non image url which mime type is allowed' do
      let(:line_1) { "https://simple-images-downloader.s3.eu-west-3.amazonaws.com/text.txt\n" }

      before do
        SimpleImagesDownloader::Configuration.valid_mime_types = ['text/plain', 'image/png']
      end

      after do
        SimpleImagesDownloader::Configuration
          .valid_mime_types = SimpleImagesDownloader::Configuration::DEFAULT_VALID_MIME_TYPES
      end

      it 'downloads image and text file' do
        expect(fixtures_files('image-fetcher/*.*')).to be_empty

        process

        expect(fixtures_files('image-fetcher/*.*')).to contain_exactly(an_instance_of(String), an_instance_of(String))

        image = File.open(fixtures_files('image-fetcher/*.png').first)
        text  = File.open(fixtures_files('image-fetcher/*.txt').first)

        expect(image.size).to be(5795)
        expect(text.size).to be(4)
      end
    end
  end
end

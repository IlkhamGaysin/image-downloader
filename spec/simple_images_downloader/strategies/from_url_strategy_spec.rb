# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleImagesDownloader::Strategies::FromUrlStrategy do
  describe '#process', :vcr do
    subject(:process) { described_class.new(url).process }

    let(:url) { 'https://simple-images-downloader.s3.eu-west-3.amazonaws.com/7.5MB.jpg' }

    context 'when there is request', :vcr do
      before do
        FileUtils.mkdir_p(fixtures_path('image-fetcher'))
        SimpleImagesDownloader::Configuration.destination = fixtures_path('image-fetcher/')
      end

      after do
        FileUtils.rm_rf(fixtures_path('image-fetcher/'))
      end

      it 'downloads image' do
        expect(fixtures_files('image-fetcher/*.*')).to be_empty

        process

        fixtures_files('image-fetcher/*.*').each do |path|
          expect(File).to be_exist(path)
        end
      end

      it 'downloads corresponding image from file' do
        expect(fixtures_files('image-fetcher/*.*')).to be_empty

        process

        image = File.open(fixtures_files('image-fetcher/*.jpg').first)

        expect(image.size).to be(7_471_971)
      end
    end

    context 'when there is no request' do
      let(:uri)        { URI.parse(url) }
      let(:line)       { instance_double('SimpleImagesDownloader::Line') }
      let(:downloader) { instance_double('SimpleImagesDownloader::Downloader') }

      it do
        expect(SimpleImagesDownloader::Line).to receive(:new).with(url).and_return(line)
        expect(line).to receive(:uri).and_return(uri)
        expect(SimpleImagesDownloader::Downloader).to receive(:new).with(uri).and_return(downloader)
        expect(downloader).to receive(:download)

        process
      end
    end
  end
end

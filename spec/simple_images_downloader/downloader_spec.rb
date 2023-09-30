# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Downloader do
  describe '#download' do
    context 'when there is redirect error', :vcr do
      let(:uri) { URI.parse('http://github.com') }

      it 'raises RedirectError', vcr: {
        cassette_name: '/SimpleImagesDownloader_Downloader/_download/when_there_is_redirect_error/1_2_1_1'
      } do
        expect { described_class.new(uri).download }.to raise_error(SimpleImagesDownloader::Errors::RedirectError)
      end
    end

    context 'when there is http error', :vcr do
      let(:uri) { URI.parse('https://github.com/IlkhamGaysin/test.png') }

      it 'raises ConnectionError', vcr: {
        cassette_name: '/SimpleImagesDownloader_Downloader/_download/when_there_is_http_error/1_2_2_1'
      } do
        expect { described_class.new(uri).download }.to raise_error(SimpleImagesDownloader::Errors::ConnectionError)
      end
    end

    context 'when downloaded file is StringIO', :vcr do
      subject(:download) { described_class.new(uri).download }

      let(:tempfile)  { instance_double('Tempfile', close: true) }
      let(:dispenser) { instance_double('SimpleImagesDownloader::Dispenser') }

      let(:uri) do
        URI.parse('https://simple-images-downloader.s3.eu-west-3.amazonaws.com/less_than_10kb.png')
      end

      before do
        FileUtils.mkdir_p(fixtures_path('downloader'))
        SimpleImagesDownloader::Configuration.destination = fixtures_path('downloader/')
      end

      after do
        FileUtils.rm_rf(fixtures_path('downloader/'))
      end

      it 'downloads file' do
        expect(File).not_to be_exist(fixtures_path('downloader/*.*'))

        download

        fixtures_files('downloader/*.*').each do |path|
          expect(File).to be_exist(path)
        end
      end

      it 'keeps images consistency' do
        expect(fixtures_files('downloader/*.*')).to be_empty

        download

        image = File.open(fixtures_files('downloader/*.png').first)

        expect(image.size).to be(5795)
      end

      it 'converts StringIO to Tempfile and places images' do
        expect(SimpleImagesDownloader::StringioToTempfile)
          .to receive(:convert).with(instance_of(StringIO)).and_return(tempfile)
        expect(SimpleImagesDownloader::Dispenser)
          .to receive(:new).with(tempfile, uri.path).and_return(dispenser)

        expect(dispenser).to receive(:place)

        download
      end

      it 'logs process', vcr: {
        cassette_name: '/SimpleImagesDownloader_Downloader/_download/when_downloaded_file_is_StringIO/1_2_3_4'
      } do
        expect { described_class.new(uri).download }
          .to output("Downloading #{uri}\nDownloading is finished\n").to_stdout
      end
    end

    context 'when Dispenser raises an error' do
      let(:uri) do
        URI.parse('https://simple-images-downloader.s3.eu-west-3.amazonaws.com/7.5MB.jpg')
      end
      let(:downloader)      { described_class.new(uri) }
      let(:stringio)        { StringIO.new }
      let(:downloaded_file) { Tempfile.new(['downloader-test', SimpleImagesDownloader::Configuration.destination]) }
      let(:dispenser)       { instance_double('SimpleImagesDownloader::Dispenser') }

      before do
        client = instance_double('SimpleImagesDownloader::Client')
        validator = instance_double('SimpleImagesDownloader::Validatable::MimeTypeValidator')

        allow(SimpleImagesDownloader::Validatable::MimeTypeValidator).to receive(:new).and_return(validator)
        allow(validator).to receive(:validate).and_return(true)
        allow(SimpleImagesDownloader::Client).to receive(:new).and_return(client)
        allow(client).to receive(:open).and_return(stringio)
        allow(SimpleImagesDownloader::StringioToTempfile).to receive(:convert).and_return(downloaded_file)
        allow(SimpleImagesDownloader::Dispenser)
          .to receive(:new).with(an_instance_of(Tempfile), uri.path).and_return(dispenser)
        allow(dispenser).to receive(:place).and_raise(SimpleImagesDownloader::Errors::BaseError)
      end

      it 'ensures that downloaded file is closed' do
        expect(downloaded_file).to receive(:close)

        expect { downloader.download }.to raise_error(SimpleImagesDownloader::Errors::BaseError)
      end

      it 'ensures stringio is closed' do
        expect(stringio).to receive(:close)

        expect { downloader.download }.to raise_error(SimpleImagesDownloader::Errors::BaseError)
      end
    end

    context 'when downloaded file is Tempfile' do
      subject(:download) { described_class.new(uri).download }

      let(:dispenser) { instance_double('SimpleImagesDownloader::Dispenser') }

      let(:uri) do
        URI.parse('https://simple-images-downloader.s3.eu-west-3.amazonaws.com/7.5MB.jpg')
      end

      before do
        FileUtils.mkdir_p(fixtures_path('downloader'))
        SimpleImagesDownloader::Configuration.destination = fixtures_path('downloader/')
      end

      after do
        FileUtils.rm_rf(fixtures_path('downloader/'))
      end

      it 'calls Dispenser#place', vcr: {
        cassette_name: '/SimpleImagesDownloader_Downloader/_download/when_downloaded_file_is_Tempfile/1_2_5_1'
      } do
        expect(SimpleImagesDownloader::Dispenser)
          .to receive(:new).with(an_instance_of(Tempfile), uri.path).and_return(dispenser)
        expect(dispenser).to receive(:place)

        download
      end

      it 'downloads file', vcr: {
        cassette_name: '/SimpleImagesDownloader_Downloader/_download/when_downloaded_file_is_Tempfile/downloads_file'
      } do
        expect(File).not_to be_exist(fixtures_path('downloader/*.*'))

        download

        fixtures_files('downloader/*.*').each do |path|
          expect(File).to be_exist(path)
        end
      end

      it 'logs process', vcr: {
        cassette_name: '/SimpleImagesDownloader_Downloader/_download/when_downloaded_file_is_Tempfile/1_2_5_3'
      } do
        expect { download }.to output("Downloading #{uri}\nDownloading is finished\n").to_stdout
      end
    end

    context 'when downloaded file is nil' do
      subject(:download) { described_class.new(uri, client).download }

      let(:uri) { URI.parse('http://github.com') }
      let(:client) { instance_double('SimpleImagesDownloader::Client') }

      before do
        allow(client).to receive(:open).and_return(nil)
      end

      it 'raises EmptyResponse' do
        expect { download }.to raise_error(
          SimpleImagesDownloader::Errors::EmptyResponse, "Nothing returned from request #{uri}"
        )
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::SourceFile do
  describe '#each_line' do
    context 'when validator is not passed' do
      subject(:each_line) { described_class.new(path).each_line { |_| } }

      let(:path) { String.new }

      it do
        expect do
          each_line
        end.to raise_error(
          SimpleImagesDownloader::Errors::MissingFileError,
          'File under  path is absent'
        )
      end
    end

    context 'when file is present' do
      let(:file) { Tempfile.new(['source-file-test', fixtures_path]) }

      let(:image_1) { Faker::Placeholdit.image }
      let(:image_2) { Faker::Placeholdit.image }

      let(:line_1) { "#{image_1}\n" }
      let(:line_2) { "#{image_2}\n" }

      before do
        [line_1, line_2].each { |line| file.write(line) }
        file.close unless file.closed?
      end

      after { file.close! unless file.closed? }

      it 'strips new line character in line' do
        expect { |b| described_class.new(file.path).each_line(&b) }.to yield_successive_args(image_1, image_2)
      end
    end

    context 'when file is not accessible due to permission issues' do
      let(:file)        { Tempfile.new(['source-file-test', fixtures_path]) }
      let(:source_file) { described_class.new(file.path) }

      before do
        file.chmod(0o0200)
      end

      after { file.close! unless file.closed? }

      it 'raises permissions error' do
        expect do
          source_file.each_line
        end.to raise_error(
          SimpleImagesDownloader::Errors::PermissionsError,
          "Couldn't read file #{file.path} due to permissions error"
        )
      end
    end

    context 'when exception is in yielded item' do
      let(:file)        { Tempfile.new(['source-file-test', fixtures_path]) }
      let(:source_file) { described_class.new(file.path) }

      before do
        allow(source_file).to receive(:file).and_return(file)
        allow(source_file).to receive(:each_line).and_raise(StandardError)
      end

      after { file.close! unless file.closed? }

      it 'closes opened file' do
        expect(file).to receive(:close)

        expect do
          source_file.each_line
        end.to raise_error(StandardError)
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe SimpleImagesDownloader::Validatable::ImagePathValidator do
  describe SimpleImagesDownloader::Validatable::ImagePathValidator::VALID_EXTENSIONS do
    subject(:valid_extensions) { described_class }

    it { is_expected.to eq(%w[.png .jpg .gif .jpeg]) }
  end

  describe '#validate' do
    subject(:validate) { described_class.new.validate(path) }

    context 'when path is empty string' do
      let(:path) { '' }

      it do
        expect do
          validate
        end.to raise_error(
          SimpleImagesDownloader::Errors::MissingImageInPath,
          "The path doesn't contain image "
        )
      end
    end

    context 'when path contains random chars' do
      let(:path) { "#{Faker::Lorem.characters}?!*&%$$@}" }

      it do
        expect do
          validate
        end.to raise_error(
          SimpleImagesDownloader::Errors::MissingImageInPath,
          "The path doesn't contain image #{path}"
        )
      end
    end

    context 'when path constants sentence' do
      let(:path) { Faker::Lorem.sentence }

      it do
        expect do
          validate
        end.to raise_error(
          SimpleImagesDownloader::Errors::MissingImageInPath,
          "The path doesn't contain image #{path}"
        )
      end
    end

    context "when path doesn't contain extension" do
      let(:path) { Faker::LoremPixel.image }

      it do
        expect do
          validate
        end.to raise_error(
          SimpleImagesDownloader::Errors::MissingImageInPath,
          "The path doesn't contain image #{path}"
        )
      end
    end

    context "when path's extension is from
      #{SimpleImagesDownloader::Validatable::ImagePathValidator::VALID_EXTENSIONS}" do
      it "doesn't raise Errors::MissingImageInPath error and returns nil" do
        SimpleImagesDownloader::Validatable::ImagePathValidator::VALID_EXTENSIONS.each do |extension|
          path = Faker::Placeholdit.image(format: extension.delete('.'))

          result = described_class.new.validate(path)

          expect(result).to be_nil
        end
      end
    end

    context "when path's extension is not from
      #{SimpleImagesDownloader::Validatable::ImagePathValidator::VALID_EXTENSIONS}" do
      let(:path) { "#{SimpleImagesDownloader::Validatable::ImagePathValidator::VALID_EXTENSIONS.sample}test" }

      it do
        expect do
          validate
        end.to raise_error(
          SimpleImagesDownloader::Errors::MissingImageInPath,
          "The path doesn't contain image #{path}"
        )
      end
    end
  end
end

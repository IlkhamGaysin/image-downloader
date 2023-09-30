# frozen_string_literal: true

require 'open-uri'
require 'tempfile'
require 'forwardable'
require 'singleton'
require 'open3'
require_relative 'simple_images_downloader/version'
require_relative 'simple_images_downloader/errors'
require_relative 'simple_images_downloader/configuration'
require_relative 'simple_images_downloader/validatable'
require_relative 'simple_images_downloader/validatable/validator'
require_relative 'simple_images_downloader/validatable/destination_validator'
require_relative 'simple_images_downloader/validatable/file_accessibility_validator'
require_relative 'simple_images_downloader/validatable/file_persistance_validator'
require_relative 'simple_images_downloader/validatable/mime_type_validator'
require_relative 'simple_images_downloader/stringio_to_tempfile'
require_relative 'simple_images_downloader/client'
require_relative 'simple_images_downloader/source_file'
require_relative 'simple_images_downloader/runner'
require_relative 'simple_images_downloader/line'
require_relative 'simple_images_downloader/dispenser'
require_relative 'simple_images_downloader/strategies/strategy'
require_relative 'simple_images_downloader/downloader'
require_relative 'simple_images_downloader/strategies/from_file_strategy'
require_relative 'simple_images_downloader/strategies/from_url_strategy'

# SimpleImagesDownloader module
# It is a main module of the gem
# It is responsible for providing interface to download images from file or url
#
# @example
#   SimpleImagesDownloader.from_file('./urls.txt')
#   SimpleImagesDownloader.from_url('https://example.com/image.jpg')
#
module SimpleImagesDownloader
  # Downloads images from file by taking urls from it. Places images to the destination folder set in configuration
  #
  # @param path [String] path to file with urls
  def self.from_file(path)
    SimpleImagesDownloader::Strategies::FromFileStrategy.new(path).process
  end

  # Downloads image from url. Places image to the destination folder set in configuration
  #
  # @param url [String] url of image
  def self.from_url(url)
    SimpleImagesDownloader::Strategies::FromUrlStrategy.new(url).process
  end

  # Returns root path of the gem. It is used for testing purposes
  # @return [String] root path of the gem
  def self.root
    File.dirname __dir__
  end
end

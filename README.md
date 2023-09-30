# Simple Images Downloader

[![IlkhamGaysin](https://circleci.com/gh/IlkhamGaysin/simple-images-downloader.svg?style=svg)](https://circleci.com/gh/IlkhamGaysin/simple-images-downloader)
[![Maintainability](https://api.codeclimate.com/v1/badges/df8b8fea5a09ad512d54/maintainability)](https://codeclimate.com/github/IlkhamGaysin/simple-images-downloader/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/df8b8fea5a09ad512d54/test_coverage)](https://codeclimate.com/github/IlkhamGaysin/simple-images-downloader/test_coverage)
[![Gem Version](https://badge.fury.io/rb/simple-images-downloader.svg)](https://badge.fury.io/rb/simple-images-downloader)

This gem allows you download images from either source file with list of urls or plain url.
The urls must be non redirectable. For now the feature is unsupported. The gem uses `OpenURI` class under the hood and is able to download as small files less than 10KB as large files, for example 100MB.

**Supported formats: png, jpg, gif, jpeg**

## Dependencies
  - Ruby >= 2.7.1

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple-images-downloader'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install simple-images-downloader

## Usage

The gem is provided with executable.

You can either run plain command with file containing list of url:

```bash
simple-images-downloader <path_to_file>
```

Or you can load gem and use public API:

- `SimpleImagesDownloader.from_file` - allows download images from file containing urls

```ruby
[1] pry(main)> require 'simple_images_downloader'

[2] pry(main)> path = File.expand_path("./urls.txt")

[3] pry(main)> SimpleImagesDownloader.from_file(path)
Downloading https://test-for-simple-images-downloader.s3.eu-central-1.amazonaws.com/7.5MB.jpg
Downloading is finished
Downloading https://test-for-simple-images-downloader.s3.eu-central-1.amazonaws.com/less_than_10kb.png
Downloading is finished
```

- `SimpleImagesDownloader.from_url` - allows download image from url

```ruby
[1] pry(main)> require 'simple_images_downloader'

[2] pry(main)> url = 'https://test-for-simple-images-downloader.s3.eu-central-1.amazonaws.com/7.5MB.jpg'

[3] pry(main)> SimpleImagesDownloader.from_url(url)
Downloading https://test-for-simple-images-downloader.s3.eu-central-1.amazonaws.com/7.5MB.jpg
Downloading is finished
```

## Configuration
**By default the images stored in a directory the script is run.**
You can also configure the place where the images would be stored to:

```ruby
[1] pry(main)> require 'simple_images_downloader'

[2] pry(main)> SimpleImagesDownloader::Configuration.configure do  |config|
[2] pry(main)*   config.destination = "./tmp/"
[2] pry(main)* end
```

**By default the gem downloads only images with mime types: image/avif, image/gif, image/apng, image/jpg, image/jpeg, image/png, image/svg+xml, image/webp.**
You can also configure the mime types to download images with:


```ruby
[1] pry(main)> require 'simple_images_downloader'

[2] pry(main)> SimpleImagesDownloader::Configuration.configure do  |config|
[2] pry(main)*   # You must use RFC 1341 - MIME (Multipurpose Internet Mail Extensions) format
[2] pry(main)*   config.valid_mime_types = %w(image/png image/jpg image/jpeg)
[2] pry(main)* end
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/IlkhamGaysin/simple-images-downloader. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/IlkhamGaysin/simple-images-downloader/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleImagesDownloader project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/IlkhamGaysin/simple-images-downloader/blob/master/CODE_OF_CONDUCT.md).

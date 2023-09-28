# frozen_string_literal: true

module SimpleImagesDownloader
  module Validatable
    def validate!(value)
      (@validators ||= []).each { |validator| validator.validate(value) }
    end
  end
end

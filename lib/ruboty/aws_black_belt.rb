require 'ruboty'
require 'ruboty/aws_black_belt/version'
require 'ruboty/aws_black_belt/profile'
require 'ruboty/handlers/aws_black_belt'
require 'i18n'

I18n.load_path += Dir[File.expand_path('../../../locale/*.yml', __FILE__)]
I18n.default_locale = :ja

module Ruboty
  module AwsBlackBelt
  end
end

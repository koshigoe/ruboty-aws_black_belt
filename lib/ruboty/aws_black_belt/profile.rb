module Ruboty
  module AwsBlackBelt
    class Profile
      PROFILE_KEYS = %i(email first_name last_name country zipcode phone company post business job usage schedule contact)
      attr_accessor :username, *PROFILE_KEYS

      def self.t(key)
        I18n.t(key, scope: 'ruboty.aws_black_belt.profile', default: key.to_s)
      end

      def initialize(username)
        @username = username
      end

      def attributes
        PROFILE_KEYS.each_with_object({}) { |k, res| res[k] = self.send(k) }
      end
    end
  end
end

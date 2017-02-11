module Ruboty
  module AwsBlackBelt
    class Profile
      attr_accessor :email, :first_name, :last_name, :country,
                    :zipcode, :phone, :company, :post, :business,
                    :job, :usage, :schedule, :contact,
                    :username

      def self.t(key)
        I18n.t(key, scope: 'ruboty.aws_black_belt.profile', default: key.to_s)
      end

      def initialize(username)
        @username = username
      end
    end
  end
end

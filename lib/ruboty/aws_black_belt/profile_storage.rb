module Ruboty
  module AwsBlackBelt
    class ProfileStorage
      attr_reader :robot

      def initialize(robot)
        @robot = robot
      end

      def save(profile)
        storage[profile.username] = profile.attributes
      end

      def load(username)
        Profile.new(username).tap { |profile| profile.assign_attributes(storage[username] || {}) }
      end

      private

      def storage
        robot.brain.data['Ruboty::AwsBlackBelt'] ||= {}
      end
    end
  end
end

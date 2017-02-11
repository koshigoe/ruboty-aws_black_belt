require 'open-uri'
require 'nokogiri'
require 'mechanize'

module Ruboty
  module Handlers
    class AwsBlackBelt < Base
      on /awsbb list/, name: 'show_schedule', description: 'Show AWS Black Belt schedule'
      on /awsbb profile\z/, name: 'show_profile', description: 'Show profile'
      on /awsbb profile\n(?<profile>.*)\z/m, name: 'save_profile', description: 'Save profile'
      on /awsbb register (?<url>.*)/, name: 'register', description: 'Register webinar'

      def show_schedule(message)
        message.reply(schedule.map { |seminar| "#{seminar[:title]}\n#{seminar[:url]}" }.join("\n"))
      end

      def show_profile(message)
        profile = Ruboty::AwsBlackBelt::ProfileStorage.new(robot).load(message.from_name)
        reply = profile.attributes.map { |k, v| "#{Ruboty::AwsBlackBelt::Profile.t(k)} = #{v}" }.join("\n")
        message.reply(reply)
      end

      def save_profile(message)
        reverse_table = Ruboty::AwsBlackBelt::Profile.reverse_translation_table

        attributes = message['profile'].split(/[\r\n]+/).each_with_object({}) do |line, res|
          k, v = line.split('=', 2).map(&:strip)
          res[reverse_table[k]] = v
        end

        profile = Ruboty::AwsBlackBelt::Profile.new(message.from_name).tap { |profile| profile.assign_attributes(attributes) }
        Ruboty::AwsBlackBelt::ProfileStorage.new(robot).save(profile)

        message.reply('done.')
      end

      def register(message)
        profile = Ruboty::AwsBlackBelt::ProfileStorage.new(robot).load(message.from_name)
        form = Ruboty::AwsBlackBelt::RegistrationForm.new(message['url'], profile)

        if form.submit
          message.reply('registered. check your mailbox.')
        else
          # TODO: show screenshot
          message.reply('Could not registered. Maybe, you have already registerd.')
        end
      rescue Ruboty::AwsBlackBelt::RegistrationForm::LandingPageNotFound
        message.reply('landing page not found.')
      rescue Ruboty::AwsBlackBelt::RegistrationForm::RegistrationPageNotFound
        message.reply('registration page not found.')
      rescue
        # TODO: show screenshot
        message.reply('something wrong...')
      end

      private

      def schedule
        result = []

        open('https://aws.amazon.com/jp/about-aws/events/webinars/') do |io|
          doc = Nokogiri::HTML(io)
          doc.css('div.lead-copy.section a').each do |element|
            next unless element.text.include?('[AWS Black Belt Online Seminar]')
            result << { url: element['href'], title: element.text }
          end
        end

        result
      end
    end
  end
end

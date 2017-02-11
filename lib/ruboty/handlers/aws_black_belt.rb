require 'open-uri'
require 'nokogiri'
require 'mechanize'

module Ruboty
  module Handlers
    class AwsBlackBelt < Base
      BRAIN_KEY = name

      on /awsbb list/, name: 'show_schedule', description: 'Show AWS Black Belt schedule'
      on /awsbb profile\z/, name: 'show_profile', description: 'Show profile'
      on /awsbb profile\n(?<profile>.*)\z/m, name: 'save_profile', description: 'Save profile'
      on /awsbb register (?<url>.*)/, name: 'register', description: 'Register webinar'

      FORM = {
        '電子メールアドレス' => 'login',
        '名' => 'first-name',
        '姓' => 'last-name',
        '国' => '58646975',
        '郵便番号' => '58646976',
        '勤務先お電話番号' => '58646977',
        '御社名・所属団体名' => '58646978',
        'お役職' => '58646979',
        '業種' => '58646980',
        '職種' => '58646981',
        'AWS 利用度' => '58646982',
        'クラウド導入の予定はいつですか？' => '58646983',
        'オンラインセミナー後、AWS の日本担当チームからご連絡させていただいてもよろしいですか' => '58646984'
      }

      def initialize(*args)
        super

        robot.brain.data[BRAIN_KEY] ||= {}
      end

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
          message.reply('something wrong...')
        end
      rescue Ruboty::AwsBlackBelt::RegistrationForm::Error
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

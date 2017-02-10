require 'open-uri'
require 'nokogiri'

module Ruboty
  module Handlers
    class AwsBlackBelt < Base
      BRAIN_KEY = name

      on /awsbb list/, name: 'show_schedule', description: 'Show AWS Black Belt schedule'
      on /awsbb config\z/, name: 'show_configuration', description: 'Show configuration'
      on /awsbb configure\n(.*)\z/m, name: 'configure', description: 'Configure personal informations to register webinar'

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

        robot.brain.data[BRAIN_KEY] = {}
      end

      def show_schedule(message)
        message.reply(schedule.map { |seminar| "#{seminar[:title]}\n#{seminar[:url]}" }.join("\n"))
      end

      def show_configuration(message)
        message.reply(configuration(message.from_name).map { |k, v| "#{k} = #{v}" }.join("\n"))
      end

      def configure(message)
        config = Hash[message[1].split("\n").map { |line| line.split("=", 2).map(&:strip) }]
        robot.brain.data[BRAIN_KEY][message.from_name] = config
        message.reply('done.')
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

      def configuration(name)
        configuration = robot.brain.data[BRAIN_KEY][name]
        return configuration if configuration

        robot.brain.data[BRAIN_KEY][name] = FORM.keys.each_with_object({}) { |(k, _), obj| obj[k] = nil  }
      end
    end
  end
end

require 'open-uri'
require 'nokogiri'

module Ruboty
  module Handlers
    class AwsBlackBelt < Base
      on /awsbb list/, name: 'show_schedule', description: 'Show AWS Black Belt schedule'

      def show_schedule(message)
        message.reply(schedule.map { |seminar| "#{seminar[:title]}\n#{seminar[:url]}" }.join("\n"))
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

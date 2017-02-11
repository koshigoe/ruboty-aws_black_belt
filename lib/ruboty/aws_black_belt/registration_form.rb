require 'mechanize'

module Ruboty
  module AwsBlackBelt
    class RegistrationForm
      class Error < StandardError; end
      class LandingPageNotFound < Error; end
      class RegistrationPageNotFound < Error; end

      FORM = {
        email: 'login',
        first_name: 'first-name',
        last_name: 'last-name',
        country: '58646975',
        zipcode: '58646976',
        phone: '58646977',
        company: '58646978',
        post: '58646979',
        business: '58646980',
        job: '58646981',
        usage: '58646982',
        schedule: '58646983',
        contact: '58646984',
      }.freeze

      attr_reader :landing_page_url, :profile, :agent

      def initialize(landing_page_url, profile)
        @landing_page_url = landing_page_url
        @profile = profile
        @agent = Mechanize.new
      end

      def submit
        form = registration_page.form_with(id: 'eventReg')
        FORM.each do |profile_key, form_key|
          form[form_key] = profile.send(profile_key)
        end
        result_page = agent.submit(form)

        result_page.form_with(id: 'eventReg').nil?
      end

      private

      def landing_page
        @landing_page ||= agent.get(landing_page_url)
      rescue
        raise LandingPageNotFound
      end

      def registration_page
        @registration_page ||= landing_page.link_with(text: 'オンラインセミナーお申込み').click
      rescue Error
        raise
      rescue
        raise RegistrationPageNotFound
      end
    end
  end
end

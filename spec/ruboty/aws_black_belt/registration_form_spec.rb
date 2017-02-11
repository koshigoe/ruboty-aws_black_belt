require 'spec_helper'

RSpec.describe Ruboty::AwsBlackBelt::RegistrationForm do
  describe '#submit' do
    subject { described_class.new(landing_page_url, profile).submit }

    let(:landing_page_url) { 'https://publish.awswebcasts.com/content/connect/c1/7/en/events/event/shared/4312879/event_landing.html?connect-session=graysonbreezq2oxw5ikbbup4m3d&sco-id=58647084&campaign-id=AWS_WWP&_charset_=utf-8' }
    let(:registration_page_url) { 'https://publish.awswebcasts.com/content/connect/c1/7/en/events/event/shared/4312879/event_registration.html?sco-id=58647084&campaign-id=AWS_WWP' }
    let(:profile) do
      Ruboty::AwsBlackBelt::Profile.new('whoami').tap do |x|
        x.email = 'test@example.com'
        x.first_name = '名'
        x.last_name = '姓'
        x.country = '日本'
        x.zipcode = '123-4567'
        x.phone = '090-1234-5678'
        x.company = '株式会社テスト'
        x.post = '社長'
        x.business = 'ソフトウェア & インターネット'
        x.job = '開発者/エンジニア'
        x.usage = 'AWSでサービスを複数本番稼動させている'
        x.schedule = ' 未定'
        x.contact = 'false'
      end
    end

    context 'landing page not found' do
      before do
        stub_request(:get, landing_page_url).to_return(status: 404)
      end

      it 'Ruboty::AwsBlackBelt::RegistrationForm::LandingPageNotFound' do
        expect { subject }.to raise_error(Ruboty::AwsBlackBelt::RegistrationForm::LandingPageNotFound)
      end
    end

    context 'landing page found' do
      before do
        stub_request(:get, landing_page_url)
          .to_return(
            body: open(File.expand_path('../../../data/landing_page.html', __FILE__)),
            headers: {
              'Content-Type' => 'text/html; charset=utf-8',
            })
      end

      context 'registration page not found' do
        before do
          stub_request(:get, registration_page_url).to_return(status: 404)
        end

        it 'Ruboty::AwsBlackBelt::RegistrationForm::RegistrationPageNotFound' do
          expect { subject }.to raise_error(Ruboty::AwsBlackBelt::RegistrationForm::RegistrationPageNotFound)
        end
      end

      context 'registration page found' do
        before do
          stub_request(:get, registration_page_url).to_return(
            body: open(File.expand_path('../../../data/registration_page.html', __FILE__)),
            headers: {
              'Content-Type' => 'text/html; charset=utf-8',
            })
        end
p
        context 'already registered' do
          before do
            stub_request(:post, 'https://publish.awswebcasts.com/content/connect/connect-action?sco-id=58647084')
              .to_return(
                body: open(File.expand_path('../../../data/already_registered.html', __FILE__)),
                headers: {
                  'Content-Type' => 'text/html; charset=utf-8',
                })
          end

          it 'return false' do
            is_expected.to eq false
          end
        end

        context 'success' do
          before do
            stub_request(:post, 'https://publish.awswebcasts.com/content/connect/connect-action?sco-id=58647084')
              .to_return(
                body: open(File.expand_path('../../../data/success.html', __FILE__)),
                headers: {
                  'Content-Type' => 'text/html; charset=utf-8',
                })
          end

          it 'return true' do
            is_expected.to eq true
          end
        end
      end
    end
  end
end

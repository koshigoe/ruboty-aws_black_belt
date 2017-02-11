require 'spec_helper'

RSpec.describe Ruboty::AwsBlackBelt::ProfileStorage do
  let(:robot) { Ruboty::Robot.new }

  describe '#save' do
    subject { described_class.new(robot).save(profile) }

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

    it 'save profile' do
      subject

      expected = {
        'email' => 'test@example.com',
        'first_name' => '名',
        'last_name' => '姓',
        'country' => '日本',
        'zipcode' => '123-4567',
        'phone' => '090-1234-5678',
        'company' => '株式会社テスト',
        'post' => '社長',
        'business' => 'ソフトウェア & インターネット',
        'job' => '開発者/エンジニア',
        'usage' => 'AWSでサービスを複数本番稼動させている',
        'schedule' => ' 未定',
        'contact' => 'false',
      }
      expect(robot.brain.data['Ruboty::AwsBlackBelt']['whoami']).to eq expected
    end
  end

  describe '#load' do
    subject { described_class.new(robot).load('whoami') }

    before do
      robot.brain.data['Ruboty::AwsBlackBelt'] = {
        'whoami' => {
          'email' => 'test@example.com',
          'first_name' => '名',
          'last_name' => '姓',
          'country' => '日本',
          'zipcode' => '123-4567',
          'phone' => '090-1234-5678',
          'company' => '株式会社テスト',
          'post' => '社長',
          'business' => 'ソフトウェア & インターネット',
          'job' => '開発者/エンジニア',
          'usage' => 'AWSでサービスを複数本番稼動させている',
          'schedule' => ' 未定',
          'contact' => 'false',
        }
      }
    end

    it 'is an instance of Ruboty::AwsBlackBelt::Profile' do
      is_expected.to be_an_instance_of(Ruboty::AwsBlackBelt::Profile)
    end

    it 'set profile items' do
      profile = subject

      expect(profile.email).to eq('test@example.com')
      expect(profile.first_name).to eq('名')
      expect(profile.last_name).to eq('姓')
      expect(profile.country).to eq('日本')
      expect(profile.zipcode).to eq('123-4567')
      expect(profile.phone).to eq('090-1234-5678')
      expect(profile.company).to eq('株式会社テスト')
      expect(profile.post).to eq('社長')
      expect(profile.business).to eq('ソフトウェア & インターネット')
      expect(profile.job).to eq('開発者/エンジニア')
      expect(profile.usage).to eq('AWSでサービスを複数本番稼動させている')
      expect(profile.schedule).to eq(' 未定')
      expect(profile.contact).to eq('false')
    end
  end
end

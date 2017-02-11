require 'spec_helper'

RSpec.describe Ruboty::AwsBlackBelt::Profile do
  describe '.t' do
    subject { described_class.t(key) }

    context 'exists key' do
      let(:key) { :email }
      it { is_expected.to eq '電子メールアドレス' }
    end

    context 'not exists key' do
      let(:key) { :not_exists }
      it { is_expected.to eq 'not_exists' }
    end
  end

  describe '#attributes' do
    subject { profile.attributes }

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

    it 'return profile items' do
      expected = {
        email: 'test@example.com',
        first_name: '名',
        last_name: '姓',
        country: '日本',
        zipcode: '123-4567',
        phone: '090-1234-5678',
        company: '株式会社テスト',
        post: '社長',
        business: 'ソフトウェア & インターネット',
        job: '開発者/エンジニア',
        usage: 'AWSでサービスを複数本番稼動させている',
        schedule: ' 未定',
        contact: 'false',
      }
      is_expected.to eq expected
    end
  end
end

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

  describe '#assign_attributes' do
    subject { profile.assign_attributes(attributes) }

    let(:profile) { described_class.new('whoami') }
    let(:attributes) do
      {
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
    end

    it 'assign attributes' do
      subject

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

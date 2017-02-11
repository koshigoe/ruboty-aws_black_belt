require 'spec_helper'

RSpec.describe Ruboty::Handlers::AwsBlackBelt do
  let(:robot) { Ruboty::Robot.new }

  describe '#show_schedule' do
    subject { robot.receive(body: "#{robot.name} awsbb list") }

    let(:schedule) do
      <<EOF.chomp
1/24（火） [AWS Black Belt Online Seminar] AWS 上の Jenkins 活用方法
https://connect.awswebcasts.com/blackbelt-jenkins-2017/event/event_info.html?campaign-id=AWS_WWP
1/25（水） [AWS Black Belt Online Seminar] AWS Storage Gateway
https://connect.awswebcasts.com/blackbelt-storage-gateway-2017125/event/event_info.html
1/31（火） [AWS Black Belt Online Seminar] AWS で実現する Disaster Recovery
https://connect.awswebcasts.com/blackbelt-dr-2017/event/event_info.html?campaign-id=AWS_WWP
2/1（水） [AWS Black Belt Online Seminar] AWS OpsWorks
https://connect.awswebcasts.com/blackbelt-opsworks-20170201/event/event_info.html?campaign-id=AWS_WWP
2/8（水） [AWS Black Belt Online Seminar] AWS Batch
https://connect.awswebcasts.com/blackbelt-awsbatch-20170208/event/event_info.html?campaign-id=AWS_WWP
2/9（木） [AWS Black Belt Online Seminar] Docker on AWS
https://connect.awswebcasts.com/blackbelt-docker-on-aws-2017/event/event_info.html?campaign-id=AWS_WWP
2/22（水） [AWS Black Belt Online Seminar] Amazon EC2 Systems Manager
https://connect.awswebcasts.com/blackbelt-ec2-systems-manager-20170222/event/event_info.html?campaign-id=AWS_WWP
2/28（火） [AWS Black Belt Online Seminar] IoT 向け最新アーキテクチャパターン
https://connect.awswebcasts.com/blackbelt-iot-on-aws-2017/event/event_info.html?campaign-id=AWS_WWP
EOF
    end

    before do
      path = File.expand_path('../../../data/webinar_schedule.html', __FILE__)
      stub_request(:get, 'https://aws.amazon.com/jp/about-aws/events/webinars/')
        .to_return(body: open(path), headers: { 'Content-Type' => 'text/html; charset=utf-8' })
    end

    it 'show schedule' do
      expect(robot).to receive(:say).with(hash_including(body: schedule))
      subject
    end
  end

  describe '#show_profile' do
    subject { robot.receive(body: "#{robot.name} awsbb profile", from_name: 'whoami') }

    context 'data not exists' do
      it 'return blank profile' do
        profile =<<EOF.chomp
電子メールアドレス = 
名 = 
姓 = 
国 = 
郵便番号 = 
勤務先お電話番号 = 
御社名・所属団体名 = 
お役職 = 
業種 = 
職種 = 
AWS 利用度 = 
クラウド導入の予定はいつですか？ = 
オンラインセミナー後、AWS の日本担当チームからご連絡させていただいてもよろしいですか = 
EOF
        expect(robot).to receive(:say).with(hash_including(body: profile))
        subject
      end
    end

    context 'data exists' do
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
          x.schedule = '未定'
          x.contact = 'false'
        end
      end

      before do
        Ruboty::AwsBlackBelt::ProfileStorage.new(robot).save(profile)
      end

      it 'return stored profile' do
        profile =<<EOF.chomp
電子メールアドレス = test@example.com
名 = 名
姓 = 姓
国 = 日本
郵便番号 = 123-4567
勤務先お電話番号 = 090-1234-5678
御社名・所属団体名 = 株式会社テスト
お役職 = 社長
業種 = ソフトウェア & インターネット
職種 = 開発者/エンジニア
AWS 利用度 = AWSでサービスを複数本番稼動させている
クラウド導入の予定はいつですか？ = 未定
オンラインセミナー後、AWS の日本担当チームからご連絡させていただいてもよろしいですか = false
EOF
        expect(robot).to receive(:say).with(hash_including(body: profile))
        subject
      end
    end
  end

  describe '#save_profile' do
    subject { robot.receive(body: "#{robot.name} awsbb profile\n#{profile}", from_name: 'whoami') }

    let(:profile) do
      <<EOF.chomp
電子メールアドレス = test@example.com
名 = 名
姓 = 姓
国 = 日本
郵便番号 = 123-4567
勤務先お電話番号 = 090-1234-5678
御社名・所属団体名 = 株式会社テスト
お役職 = 社長
業種 = ソフトウェア & インターネット
職種 = 開発者/エンジニア
AWS 利用度 = AWSでサービスを複数本番稼動させている
クラウド導入の予定はいつですか？ = 未定
オンラインセミナー後、AWS の日本担当チームからご連絡させていただいてもよろしいですか = false
EOF
    end

    it 'save profile' do
      expect(robot).to receive(:say).with(hash_including(body: 'done.'))
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
        'schedule' => '未定',
        'contact' => 'false',
      }
      expect(robot.brain.data['Ruboty::AwsBlackBelt']['whoami']).to eq expected
    end
  end
end

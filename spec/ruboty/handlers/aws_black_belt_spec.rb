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
end

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
end

require 'spec_helper'

describe 'git' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('git').with_ensure('installed') }
    end
  end
end

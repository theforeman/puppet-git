require 'spec_helper'

describe 'git::repo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:title) { 'mygit' }
      let(:params) do
        {
          :target  => '/tmp/somerepo.git',
          :bare    => true,
          :source  => false,
          :user    => 'root',
          :workdir => '/tmp',
          :args    => '-c core.sharedRepository=true',
          :bin     => 'git'
        }
      end

      it do
        should contain_exec('git_repo_for_mygit').with(
          'command' => "git init -c core.sharedRepository=true --bare /tmp/somerepo.git",
          'creates' => '/tmp/somerepo.git/objects',
          'cwd'     => '/tmp',
          'user'    => 'root'
        )
      end
    end
  end
end

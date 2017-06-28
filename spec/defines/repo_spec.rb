require 'spec_helper'

describe 'git::repo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:title) { 'mygit' }

      context 'with minimal parameters' do
        let :pre_condition do
          'include ::git'
        end

        let(:params) do
          {
            :target => '/tmp/somerepo',
          }
        end

        binary = ['DragonflyBSD', 'FreeBSD'].include?(facts[:osfamily]) ? '/usr/local/bin/git' : '/usr/bin/git'

        it do
          should contain_exec('git_repo_for_mygit').with(
            'command' => "#{binary} init  /tmp/somerepo",
            'creates' => '/tmp/somerepo/.git',
            'cwd'     => '/tmp',
            'user'    => 'root',
          )
        end
      end

      context 'with explicit parameters' do
        let(:params) do
          {
            :target  => '/tmp/somerepo.git',
            :bare    => true,
            :source  => false,
            :user    => 'root',
            :workdir => '/tmp',
            :args    => '-c core.sharedRepository=true',
            :bin     => 'git',
          }
        end

        it do
          should contain_exec('git_repo_for_mygit').with(
            'command' => "git init -c core.sharedRepository=true --bare /tmp/somerepo.git",
            'creates' => '/tmp/somerepo.git/objects',
            'cwd'     => '/tmp',
            'user'    => 'root',
          )
        end
      end
    end
  end
end

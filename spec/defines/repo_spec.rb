require 'spec_helper'

describe 'git::repo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:title) { 'mygit' }

      context 'with inherited parameters' do
        let :pre_condition do
          'include git'
        end

        let(:params) do
          {
            :target => '/tmp/somerepo',
          }
        end

        binary = ['DragonflyBSD', 'FreeBSD'].include?(facts[:osfamily]) ? '/usr/local/bin/git' : '/usr/bin/git'

        context 'with minimal parameters' do
          it do
            should contain_exec('git_repo_for_mygit').with(
              'command' => "#{binary} init  /tmp/somerepo",
              'creates' => '/tmp/somerepo/.git',
              'cwd'     => '/tmp',
              'user'    => 'root',
            )
          end
        end

        context 'with source' do
          let(:params) { super().merge(source: 'https://git.example.com/repo.git') }

          context 'full repo' do
            it do should contain_exec('git_repo_for_mygit')
              .with_command("#{binary} clone  --recursive https://git.example.com/repo.git /tmp/somerepo")
            end
          end

          context 'bare repo' do
          let(:params) { super().merge(bare: true) }
            it do should contain_exec('git_repo_for_mygit')
              .with_command("#{binary} clone  --bare --recursive https://git.example.com/repo.git /tmp/somerepo")
            end
          end
        end
      end

      context 'with explicit parameters' do
        let(:params) do
          {
            :target  => '/tmp/somerepo.git',
            :bare    => true,
            :source  => 'https://git.example.com/repo.git',
            :user    => 'root',
            :workdir => '/tmp',
            :args    => '-c core.sharedRepository=true',
            :bin     => 'git',
          }
        end

        it do
          should contain_exec('git_repo_for_mygit').with(
            'command' => "git clone -c core.sharedRepository=true --bare --recursive https://git.example.com/repo.git /tmp/somerepo.git",
            'creates' => '/tmp/somerepo.git/objects',
            'cwd'     => '/tmp',
            'user'    => 'root',
          )
        end
      end
    end
  end
end

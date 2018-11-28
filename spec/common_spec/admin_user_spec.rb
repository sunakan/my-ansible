require 'spec_helper'

describe '管理者用ユーザの作成' do
  describe user('kamisama') do
    it { should exist }
  end

  %w(kamisama staff sudo).each do |group|
    describe user('kamisama') do
      it { should belong_to_group(group) }
    end
  end

  describe user('kamisama') do
    it { should have_uid(9999) }
  end

  describe file('/etc/sudoers.d/kamisama') do
    it { should exist }
  end
end

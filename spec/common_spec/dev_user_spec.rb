require 'spec_helper'

describe '開発者用ユーザの作成' do
  describe user('sunakan') do
    it { should exist }
  end

  %w(developers staff sudo).each do |group|
    describe user('sunakan') do
      it { should belong_to_group(group) }
    end
  end

  describe user('sunakan') do
    it { should have_uid(10001) }
  end
end

require 'spec_helper'

describe '開発で最低限欲しいパッケージを入れる' do
  %w(vim git tig tmux tree psmisc).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end


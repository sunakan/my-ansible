require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

# 環境変数 SPEC_ENV で環境名を指定。Railsのパクリ
spec_env = ENV.fetch('SPEC_ENV') { 'development' }

env_dir    = File.expand_path("../inventories/#{spec_env}", __FILE__)
hosts_file = File.expand_path("#{env_dir}/hosts.yml")
unless File.exists?(hosts_file)
  msg = "ERROR: SPEC_ENV=#{spec_env} のhosts.ymlがありません。\n#{hosts_file}"
  raise RuntimeError, msg
end

group_hosts = YAML.load_file(hosts_file)

task spec:    'spec:all'
task default: :spec

properties = group_hosts.each_with_object({}) {|(group,v), h|
  h[group] = {
    hosts: v['hosts'].keys,
    roles: YAML.load_file("#{group}.yml")[0]['roles'],
  }
}

# spec:groups:hostの定義(例 rake spec:webservers:ayanami)
namespace :spec do
  # 全て実行するタスク (spec:all)
  desc "All target for #{spec_env}"
  task all: properties.map { |group, info| info[:hosts].map { |host| "spec:#{group}:#{host}" } }.flatten

  properties.each do |group, info|
    role_pattern = properties[group][:roles].map { |role| "#{role}_spec" }.join(',')
    namespace group.to_sym do
      desc "All target of #{group} for #{info[:hosts].join(',')}"
      task all: properties[group][:hosts].map { |host| "spec:#{group}:#{host}" }

      info[:hosts].each do |host|
        desc "Run serverspec test to #{group}: #{host} for #{role_pattern}"
        RSpec::Core::RakeTask.new(host.to_sym) do |t|
          ENV['TARGET_HOST'] = host
          ENV['SPEC_ENV']    = spec_env
          t.pattern = "spec/{#{role_pattern}}/*_spec.rb"
        end
      end
    end
  end
end

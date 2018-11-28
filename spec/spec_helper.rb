require 'serverspec'
require 'net/ssh'
require 'highline/import'

case ENV['SPEC_BACKEND']
## 環境変数 SPEC_BACKEND がdocker|DOCKERだったらSSHじゃなくてDockerバックエンドを使う。
when 'DOCKER', 'docker'
  #set :backend, :docker
  #set :docker_url, ENV['DOCKER_HOST'] || 'unix:///var/run/docker.sock'
  ### Dockerでためす場合、DOCKER_IMAGEを指定する。
  #set :docker_image, ENV['DOCKER_IMAGE']
  #set :docker_container_create_options, {'Cmd' => ['/bin/sh']}
  #Excon.defaults[:ssl_verify_peer] = false
else
  ## デフォルトのバックエンドはSSH
  set :backend, :ssh
  set :request_pty, true

  ## このへんはRakeと一緒、定義ファイルを決定
  spec_env = ENV['SPEC_ENV']
  env_dir  = File.expand_path("../../inventories/#{spec_env}", __FILE__)
  hosts_file = File.expand_path("#{env_dir}/hosts.yml")
  unless File.exists?(hosts_file)
    msg = "ERROR: SPEC_ENV=#{spec_env} のhosts.ymlがありません。\n#{hosts_file}"
    raise RuntimeError, msg
  end

  ## spec_helperでもRakefile同様にホスト定義を読み込む
  group_hosts = YAML.load_file(hosts_file)
  properties = group_hosts.each_with_object({}) {|(group,v), h|
    h[group] = {
      hosts: v['hosts'],
      roles: YAML.load_file("#{group}.yml")[0]['roles'],
    }
  }

  host = ENV['TARGET_HOST']

  ## 環境別SSH接続設定をマージしていく
  options = Net::SSH::Config.for(host)

  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }

  set :host, options[:host_name] || host
  set :ssh_options, options

  # Disable sudo
  # set :disable_sudo, true

  RSpec.configure do |config|
    config.color = true
    config.tty = true
  end

  # Set environment variables
  set :env, :LANG => 'C', :LC_MESSAGES => 'C'
end

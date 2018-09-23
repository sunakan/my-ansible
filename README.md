# 自分なりのAnsibleメモ

## ディレクトリ構成のBase

Ansibleのベストプラクティスの「Alternative Directory Layout」

## development

### 事前に準備

- 一部変数を暗号化しているため、復号化用のANSIBLE\_VAULT\_PASSWORD
- VirtualBox + Vagrantによる以下の3つのサーバ(Vagrantfileは後述)
  - ayanami
  - shinji
  - asuka

~~~
$ ansible-playbook -i inventories/development/hosts.yml site.yml
~~~

# 自分なりのAnsibleメモ
- ansible-galaxyというのもあるらしいが、とりあえず勉強用
- Ansible Tutorialというのもあることを確認

## ディレクトリ構成のBase

Ansibleのベストプラクティスの「Alternative Directory Layout」

## 構成
- VM3つ(inventories/development/hosts.ymlに記述)
  - ayanami
  - shinji
  - asuka
- PrivateIPは決め打ち
- Vagrantを利用している前提(ssh\_user=vagrant)
- Debian系(aptを使用)

## 事前に準備

- 一部変数を暗号化しているため、復号化用のANSIBLE\_VAULT\_PASSWORDを準備
- VirtualBox + Vagrantによる以下の3つのサーバ(Vagrantfileは後述)
  - ayanami
  - shinji
  - asuka

## 実行方法

~~~
$ ansible-playbook -i inventories/development/hosts.yml site.yml --ask-vault-pass
or
$ ansible-playbook -i inventories/development/hosts.yml site.yml --vault-password-file=ANSIBLE_VAULT_PASSWORD
~~~

## 注意
もしvault-password-fileを指定するならReadOnly

```
$ chmod 444 ANSIBLE_VAULT_PASSWORD
```

## 備忘録: 何を構成するかはsite.ymlを見ていけばだいたい分かる
- 上記のplaybookはsite.ymlを-iオプションで指定されたインベントリ郡に対して構成するよーという解釈
- 入れたい機能毎にroleに分ける(いきなり分け過ぎも良くないらしい(もっと勉強してから分ける))
- treeコマンドでディレクトリ構成を俯瞰したらなんとなく思い出すと思う

## 変数の暗号化方法
暗号化
1. 標準出力で出す
2. inventories/integration/group\_vars/webservers.ymlなどにコピペ
3. `--vault-password-file=ANSIBLE_VAULT_PASSWORD`というオプションをつけると楽

~~~
$ echo -n 'PASSWORD' | ansible-vault encrypt_string --vault-password-file=ANSIBLE_VAULT_PASSWORD
~~~

- 2,3回同じコマンドを叩いても、同じ暗号化された文字列がでるわけではないので、注意

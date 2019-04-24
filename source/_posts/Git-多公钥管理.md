---
title: Git 多公钥管理
date: 2017-10-12 20:09:19
tags:
- Git
- ssh
---

## 生成ssh key

```shell
ssh-keygen -t rsa -C "my@mail.com"
```
第一个问询命令是创建的公钥名，这里不要直接enter，键入能理解的公钥名如`id_rsa_github`，二三个命令是询问密码，无需输入

当然，也可以直接强制输入直接生成
```shell
ssh-keygen -t rsa -C "my@mail.com" -f ~/.ssh/id-rsa_github
```

## 将公钥添加到仓库的ssh key管理

## 生成key管理
创建config文件，
```shell
# github
Host github.com
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa_github
    User Jsonya
```

## 添加公钥
```shell
ssh-add ~/.ssh/id_rsa_gitlab
```

## 测试是否添加成功
```shell
ssh -T git@gitlab.com
```

## 重置全局name
```shell
git config --global --unset user.name
git config --global --unset user.email

```
如果之前创建过全局的name则运行上面的命令，重置，然后在项目的仓库中设置局部的name和email

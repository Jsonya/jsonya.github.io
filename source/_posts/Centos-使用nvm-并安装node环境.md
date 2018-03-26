---
title: Centos 使用nvm 并安装node环境
date: 2018-03-26 19:40:20
tags:
- Centos
- nvm
---

## 安装epel源
- 32位
```
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
```

- 64位
```
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
```

- 导入key
```
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
```

- 查看rpm是否已经安装
```
rpm --version
```

## 安装nvm
- 安装
```
curl: curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
```

- 重启shell

## 安装node
```
nvm install version
```
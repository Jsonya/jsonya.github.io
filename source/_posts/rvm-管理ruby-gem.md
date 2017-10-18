---
title: rvm 管理ruby&gem
date: 2017-10-18 23:17:15
tags:
- rvm
- ruby
- gem
---


```
系统： macOS
```

## what

RVM 是一个命令行工具，可以提供一个便捷的多版本 Ruby 环境的管理和切换

[https://rvm.io/](https://rvm.io/)

## install
前提是安装了xcode

```shell
curl -sSL https://get.rvm.io | bash -s stable

source ~/.bashrc

source ~/.bash_profile
```

## change ghost
切换`ruby-china`的镜像

```shell
echo "ruby_url=https://cache.ruby-china.org/pub/ruby" > ~/.rvm/user/db
```

## use ruby
1. 列出已知的 Ruby 版本
```shell
rvm list known
```

2. 安装一个 Ruby 版本
```shell
rvm install 2.4.1
```

3. 切换 Ruby 版本
```shell
rvm use 2.4.1
```

4. 查询已经安装的版本
```shell
rvm list
```

5. 移除版本
```shell
rvm remove 2.4.1
```

## install rails
1. 安装rails
```shell
gem install rails
```
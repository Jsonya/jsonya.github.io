---
title: 纯记录nvm管理node版本
date: 2017-10-11 17:36:53
tags:
- nvm
- node
- npm
---

```
系统： macOS
```

## 安装
原本打算用homebrew安装，但是看了下[nvm](https://github.com/creationix/nvm)的说明目前homebrew还不支持，故放弃

系统是macOS,所以需要先安装xcode，不想安装的话就`xcode-select --install`安装需要的

curl
```shell
curl: curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
```

wget
```shell
wget: wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
```

安装完后还需要在`~/.zshrc`添加
```
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
```

## 安装nodejs
1. 安装指定版本的 Node.js
```shell
nvm install [version]
```

2. 指定当前使用的 Node.js 版本
```shell
nvm use [version]
```

3. 查看当前安装的 Node.js 版本列表
```shell
nvm ls
```

4. 查看远程可安装的版本
```shell
nvm ls-remote
nvm ls-remote --lts //稳定版本
```

5. 切换最新版本
```shell
nvm use node
```

6. 设定默认版本
```shell
nvm alias default [version]
```

7. 当前使用版本
```shell
nvm current
`````

## 项目下
正常来说项目目录下会有一个`.nvm`记录了项目所使用的`node`版本的，所以直接运行`nvm use`就可以切换node版本为项目所使用的版本


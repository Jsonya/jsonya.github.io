---
title: sentry上传sourcemap
date: 2018-07-03 09:46:15
tags:
 - sentry
 - sourcemap
 - 监控
 - webpack
---

PS: 本文并没完全成文

### 前言
阅读这篇文章的大前提是你已经创建了一个sentry项目，但是希望在sentry的报错中能够提示更多的信息，所以希望通过sourcemap来定位问题。这篇文章基于vue-cli中的webpack模式，其他模式原理一样。
<span data-type="color" style="color:#F5222D">注意</span>：本文只是提供思路，并不可以用于生产环境，因为涉及到打包流程，而每个项目的打包方式并不一致，所以可以根据此思路去实现自己的上报流程。

### sentry-cli构建
#### 1)、生成api-key
这一步主要是用来上传时登录需要，点击头像 => 点击API keys


![1.jpg | center | 262x507](https://cdn.yuque.com/yuque/0/2018/jpeg/85168/1530582273583-8b66fa0f-3da1-470a-95b0-d7abaad98235.jpeg "")


如果你已经创建过token，你的界面会和我一样，如果没创建，根据提示创建即可，但注意一点的是，需要勾选project:write， 复制对应的token


![2.jpg | center | 747x442](https://cdn.yuque.com/yuque/0/2018/jpeg/85168/1530582295319-39b405bc-aad5-4ca1-a615-654fc720d053.jpeg "")


#### 2）、安装sentry-cli
* 先全局安装sentry-cli
```powershell
npm install sentry-cli-binary -g
```

* 安装完成后登录sentry
```powershell
sentry-cli login
```

这时会提示输入token，把刚才第一步创建的token粘贴到这里，运行


![image.png | left | 827x262](https://cdn.yuque.com/yuque/0/2018/png/85168/1530552637553-bb8e18c0-19d2-4786-bc20-d616859a5ce8.png "")


然后你会看到提示创建了一个.sentrylrc文件，文件的内容如下


![image.png | left | 827x140](https://cdn.yuque.com/yuque/0/2018/png/85168/1530549427107-c112d15b-ab27-4ac1-aaef-bb385a819477.png "")


补充org和project信息


![image.png | left | 827x190](https://cdn.yuque.com/yuque/0/2018/png/85168/1530549601530-bf3a233c-c3bf-4553-a295-f8bd40f48ce3.png "")


#### 3）、注入异常
我们在代码中，注入一些异常，并指定release版本


![image.png | left | 827x216](https://cdn.yuque.com/yuque/0/2018/png/85168/1530553222545-09b4d190-900b-444d-b1ca-761126577cf6.png "")


#### 4)、构建代码
运行命令
```powershell
npm run build
```
最终会在根目录生成dist文件夹。

#### 5)、上传sourcemap
```powershell
# sentry-cli releases files <release名称> upload-sourcemaps --url-prefix <线上资源URI> <打包出来的js文件所在目录>
sentry-cli releases files demo-test001 upload-sourcemaps --url-prefix 'http://127.0.0.1:6324/static/js' './dist/static/js'

# 我这个例子中线上资源是因为我在本地通过http-server起了一个服务来访问
# 如果你也希望这么做，你可以
npm i -g http-server 
cd dist
http-server -p 6324

```

运行例子后的结果如图


![image.png | left | 827x239](https://cdn.yuque.com/yuque/0/2018/png/85168/1530551995963-fc26e3b2-a396-4da7-83ff-fafdde7fdf1b.png "")


打开sentry的项目，查看版本，会发现多了一些资源，但实际上有用的是map文件，所以在上传完成后需要根据实际情况在构建脚本中把对应的map文件删除，避免打包到生产中(其中一个原因是文件太大，另一个原因是不安全)。



![image.png | left | 827x453](https://cdn.yuque.com/yuque/0/2018/png/85168/1530552025253-ef08a98e-f68f-4ef5-820b-e83c0642a647.png "")

#### 6）、触发异常
这时，你可以通过访问本地的[http://127.0.0.1:6324](http://127.0.0.1:6324)，然后触发我们构建的异常，因为我本地构建了一个服务，如果你也希望构建此服务，你可以通过安装http的服务包，但需要注意的是，此端口需要和之前上传文件时的端口保持一致
```
npm i -g http-server
```

此时会看到控制台抛出异常，同时会发送一个请求到sentry的服务器


![image.png | left | 596x167](https://cdn.yuque.com/yuque/0/2018/png/85168/1530552048090-1dd97d49-cb55-4ea4-888b-6205b06b878d.png "")


此时打开sentry的控制台，你会看到刚才触发的错误


![image.png | left | 685x201](https://cdn.yuque.com/yuque/0/2018/png/85168/1530552069838-9cea92c0-f28d-49d9-b5a0-281488cf6a0b.png "")

打开这个错误，就可以看到具体的错误信息，定位问题变得更加容易


![image.png | left | 827x313](https://cdn.yuque.com/yuque/0/2018/png/85168/1530552097473-e3b62274-0b44-46b8-8008-748552f97e1c.png "")



### <span data-type="background" style="background-color:rgb(248, 248, 248)">@sentry/webpack-plugin构建</span>
上面利用sentry-cli构建时，相对麻烦，而且会暴露key等一些信息，所以我们希望利用webpack插件来加快我们的上传。

1)、安装@sentry/webpack-plugin插件, 一般会同时安装@sentry/cli
```powershell
npm i @sentry/webpack-plugin --dev
```

2）、根目录创建.sentryclirc文件
```yaml
[defaults]
url = https://sentry.io/
org = your org
project = your project

[auth]
token = your token

```

3)、在config/prod.env.js创建环境变量
```javascript
// config/prod.env.js

const release = 'demo-test006'; // 可以根据package.json的版本号或者Git的tag命名
process.env.RELEASE_VERSION = release;
module.exports = {
  NODE_ENV: '"production"',
  RELEASE_VERSION: `"${release}"`,
}
```


4)、写入插件
```javascript
// build/webpack.prod.config.js

const SentryPlugin = require('@sentry/webpack-plugin')
// ...省略一堆

plugins: [
  // ...省略一堆
  new SentryPlugin({
    include: './dist',
    release: process.env.RELEASE_VERSION,
    configFile: 'sentry.properties',
    urlPrefix: 'http://127.0.0.1:6324/'
  })
]
```

5)、运行打包
```javascript
npm run build
```

此时在服务中打开触发错误，你就会在sentry中查看到具体的错误信息。对比cli构建的方式，webpack的优势还是蛮大的，但是利用cli的好处是我可以把token放在服务器，这样就可以避免token的泄露。

### 增强sentry异常捕捉
续。。

### sentry的小知识点
* __发送邮件__
一般来说，sentry是默认会打开邮箱发送选项的，如果触发错误后并没有收到邮件，你可以点击下方的框框，勾选邮件


![Jietu20180703-024254.jpg | center | 827x295](https://cdn.yuque.com/yuque/0/2018/jpeg/85168/1530557058391-83dcb6ff-9884-4e26-8558-1b4a0753ae7e.jpeg "")



![Jietu20180703-024327.jpg | center | 827x464](https://cdn.yuque.com/yuque/0/2018/jpeg/85168/1530557066190-d430040e-ae0a-4eb9-9f7b-5f1d895ae74c.jpeg "")



![Jietu20180703-024359.jpg | center | 827x393](https://cdn.yuque.com/yuque/0/2018/jpeg/85168/1530557074150-52ca715a-c774-4fef-89b1-cd6ef5a77973.jpeg "")


* 设置触发异常的用户,更有利于追踪，文档：[https://docs.sentry.io/learn/context/](https://docs.sentry.io/learn/context/)
    ```javascript
    Raven.setUserContext({
      user: 'xxx',
      id: 'sss',
    });
    ```

* Issue关联GITHUB/GITLAB（暂时用处不大）


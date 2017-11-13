---
title: mac 修改mysql密码
date: 2017-11-13 17:05:52
tags: mysql
---

#### 设备
```
mac
```

#### 安全模式打开`Mysql`
```shell
mysqld_safe --skip-grant-tables
```

#### 新窗口下修改密码
1. 登录
```shell
mysql -u root
```

2. 修改密码
```shell
UPDATE mysql.user SET Password=PASSWORD('NewPassword') WHERE user='root'
```

3. 刷新
```shell
FLUSH PRIVILEGES
```

4. 退出
```shell
\q
```

5. 重启
```shell
mysql.server restart
```

#### 重新登录
```shell
mysql -u root -p
```
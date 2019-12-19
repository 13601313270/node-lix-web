kod 框架是一种基于时间流的 php 框架，是构建API服务的首选。

当然kod不止能构建API服务，也可以用于构建网站，内置使用smarty模板，并增加了若干优化功能，kod官网本身就是通过kod开发的。

## 项目初始化
### 拉取kod框架
创建一个项目根目录，在根目录下拉取kod框架

```shell
git clone git@github.com:13601313270/kod.git
cd kod
git submodule init
git submodule update
```
kod项目有一些其他的子模块，需要进入执行模块初始化
### 拉取metaPHP框架
同时在根目录拉取metaPHP，metaPHP是一个自动化生成php代码的引擎，我们可以用自动化的形式生成整个项目初始化文件。将来很多代码也将会用自动化的形式生成
```shell
git clone git@github.com:13601313270/metaPHP.git
```
拉完两个框架之后的目录

![image](https://upload-images.jianshu.io/upload_images/8105934-2b0e749b1333e37a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 执行初始化命令
```shell
php kod/build/projectInit.php
```
根据引导，系统获取一些关键配置信息，之后就能生成整个项目目录
这些配置有，数据库地址、账号、密码，默认库，还有几个缓存文件夹路径配置

![image](https://upload-images.jianshu.io/upload_images/8105934-1ae8142077c95670.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们推荐缓存文件夹直接回车，设置默认值
### 服务器配置
使用kod的项目必须使用单一入口，比如apache的配置如下
```shell
&lt;VirtualHost *:80&gt;
    ServerName www.kodphp.cn:80
    DocumentRoot "/var/www/kodphp"
    &lt;Directory "/var/www/kodphp"&gt;
        Options FollowSymLinks
        AllowOverride None
        Require all granted
    &lt;/Directory&gt;
    RewriteRule ^.*$ /index.php [L]
&lt;/VirtualHost&gt;
```

我们需要把刚刚设置的smarty_cache路径手动创建，并且权限改为777
```shell
chmod 777 smarty_cache/
```

这时候，你再次刷新页面，就会有这样的显示。就证明初始化工作已经完成。
![image](https://upload-images.jianshu.io/upload_images/8105934-c1616ab87bf5ef1e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

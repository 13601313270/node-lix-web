{extends file="./template.tpl"}
{block name="container"}
    kod 框架是一种基于时间流的 php 框架，是构建API服务的首选。
    当然kod不止能构建API服务，也可以用于构建网站，内置使用smarty模板，并增加了若干优化功能，kod官网本身就是通过kod开发的。
    <h4>项目初始化</h4>
    <p>创建一个项目根目录，在根目录下拉取kod框架</p>
    <code>
        <span>git clone git@github.com:13601313270/kod.git</span>
        <span>cd kod</span>
        <span>git submodule init</span>
        <span>git submodule update</span>
    </code>
    <p>kod项目有一些其他的子模块，需要进入执行模块初始化</p>
    <p>同时在根目录拉取metaPHP，metaPHP是一个自动化生成php代码的引擎，我们可以用自动化的形式生成整个项目初始化文件。将来很多代码也将会用自动化的形式生成</p>
    <code>git clone git@github.com:13601313270/metaPHP.git</code>
    <p>拉完两个框架之后的目录</p>
    <img src="https://upload-images.jianshu.io/upload_images/8105934-2b0e749b1333e37a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"/>
    <h4>开始初始化</h4>
    <code>php kod/build/projectInit.php</code>
    <p>执行以后，根据引导就能生成整个项目目录</p>
    <img src="https://upload-images.jianshu.io/upload_images/8105934-1ae8142077c95670.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240">
    <p>输入数据库地址、账号、密码，选择默认库，几个文件夹路径配置</p>
    <p>服务器配置</p>
    <p>使用kod的项目必须使用单一入口</p>
    <p>比如apache的配置如下</p>
    <code>
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
    </code>
    <p>我们需要把刚刚设置的smarty_cache路径手动创建，并且权限改为777</p>
    <p>chmod 777 smarty_cache/</p>
    <p>这时候，你再次刷新页面，就会有这样的显示。就证明初始化工作已经完成。</p>
    <img src="https://upload-images.jianshu.io/upload_images/8105934-c1616ab87bf5ef1e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240">
    <style>
        code {
            background: #282c34;
            color: white;
            padding: 5px;
            border-radius: 2px;
        }
    </style>
{/block}

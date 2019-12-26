上两节讲了如果做路由分发和截获。
`kod_web_restApi`这个抽象类，自带一个step，可以渲染输出模板。这个step就是fetch。

# 使用

```php
restApi::get()
    ->run(function () {
        $aMdds = mdd::create()
            ->where(array(
                'name' => array("三亚","北京","哈尔滨")
            ))->get();
        return array(
            'mdds' => $aMdds,
        );
    })
    ->fetch('mdd/index.tpl')
```

fetch也是一个step，参数是一个tpl地址。
传统的mvc目录结构，会将所有的控制器和模板分裂的两个独立的文件夹，例如control和template。但是KOD官方建议tpl文件和控制器php文件并列部署，就像这样。

![](https://www-kodphp-cn.oss-cn-beijing.aliyuncs.com/7B44BD09-6B3D-4843-AA39-844E40A1C42F.png)

这是因为从业务角度看，同一个页面的逻辑和展示是高度内聚的。


系统使用smarty模板引擎，具体使用方法可以去[https://www.smarty.net/docs/zh_CN/](https://www.smarty.net/docs/zh_CN/ "With a Title")来阅读
并且在模版引擎的基础上做了一些扩展。


# 样式自动css文件提取
本网站本身也是用kod作为开发框架开发的，本网站的开发代码在GitHub上，我们来看一个本网站的tpl模板文件
[https://github.com/13601313270/kodphp_web/blob/master/src/template.tpl](https://github.com/13601313270/kodphp_web/blob/master/src/template.tpl)

![](https://www-kodphp-cn.oss-cn-beijing.aliyuncs.com/WX20191223-115712.png)

如上边的例子，kod鼓励把tpl里html对应的样式直接<style\>写入tpl文件里，这样可以将一一对应的html和css放在一起，方便管理，防止分离造成的样式膨胀。
系统会自动把这些style，自动提取成单独的.css文件。
![](https://www-kodphp-cn.oss-cn-beijing.aliyuncs.com/1577073811147.jpg)

开通这样的功能很简单，只要在根目录include.php文件设置两个全局参数

`KOD_SMARTY_CSS_DIR`   系统自动提取生成的css文件的存储路径（需要设置可写权限）

`KOD_SMARTY_CSS_HOST`  加载这个css文件的域名和路径（KOD\_SMARTY\_CSS\_DIR文件夹里的文件，只有服务器做了rewrite，指定访问路径才可以被浏览器访问）
（有时候网站需要单独的css域名，比如马蜂窝的就是css.mafengwo.net）

比如本网站的配置如下
[https://github.com/13601313270/kodphp_web/blob/master/include.php](https://github.com/13601313270/kodphp_web/blob/master/include.php)

# LESS支持
如果内嵌的<style\>添加一个 lang="less"，那么就可以按照less的语法写css了。就像这样。

`&lt;style lang="less">`


具体使用方法，可参阅 http://lesscss.cn/

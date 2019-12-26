系统有一个专门做路由截获判断的类，搭配路由分发类`kod_web_rewrite`使用，起到更方便的路由分发和截获。
`kod_web_restApi`是个抽象类，我们需要继承出一个实体类才可以使用，系统初始化的时候，就在/include/restApi创建了一个这样的类。这个类将来还要扩展很多方法，实现中间件，实现更方便的路由，初始化完是一个继承`kod_web_restApi`的空类。
```php
class restApi extends kod_web_restApi
{
}
```

# 使用
假设我们在根目录/rewrite.conf添加了一条配置

```shell
/ /index.php
```
这句话表示，当浏览器访问网站首页，访问会指向/src/index.php（所有路由配置都以src为基准）

这时我们在`/src/index.php`截获这个请求
```php
// 注册事件捕获get请求
restApi::get()
	->run(function(){
		return array('result'=>1);
	})
```
浏览器将输出`{result:1}`。

上面两句都是注册捕获的get事件，使用restApi::get即可，当然也可以捕获post,put,delete事件restApi::post、restApi::put、restApi::delete，捕获其他类型的http请求。
```php
// 捕获get请求
restApi::get()
	->run(function(){
		return array('result'=>'hello get');
	})
// 捕获post请求
restApi::post()
	->run(function(){
		return array('result'=>'hello post');
	})
// 捕获put请求
restApi::put()
    ->run(function(){
        return array('result'=>'hello put');
    })
// 捕获delete请求
restApi::delete()
    ->run(function(){
        return array('result'=>'hello delete');
    })
```
# 参数
### 定义
```shell
/article
    /detail/(\d+)     /article.php?id=$1      detail
```
以上面的路由举例，配置的php文件后面有一个?id=$1，代表左侧正则的一个匹配项，将作为参数id。

比如，如果浏览器地址是/article/list/29110，我们将把`29110`作为`db`参数。

网址后面添加参数，例如浏览器访问`/article/list/29110?user=wang`，也会作为参数。系统将接收两个参数`id`和`user`。

同时post发上来的数据，将与之合并，自动成为参数。

优先级：  路由参数 > get > post

### 捕获

截获器怎么使用系统生成的参数呢？截获器后面调用的->run方法绑定的匿名函数，匿名函数添加的参数，就代表业务使用的参数，其余的都将抛弃。

比如，下面的例子，匿名函数添加了一个参数db，类型是int。
```php
restApi::get('detail')
	->run(function(int db){
		return array('result'=>'hello detail'.db);
	})
```
代表这个请求，需要db参数，而且必须是整形的。如果缺少这个参数，或者类型不对，都会报错。

比如：
```shell
/article
    /detail/(\d+)     /article.php?id=$1      detail
```
这个配置遇到了下面这样的捕获器
```php
restApi::get('detail')
	->run(function(string $type){
		return 'type:'.$type;
	});
```
![](https://www-kodphp-cn.oss-cn-beijing.aliyuncs.com/1577342159149.jpg)

如果你需要给某个网址参数添加默认值，那么可以给函数参数添加默认值即可
```php
restApi::get('detail')
	->run(function(string $type="default"){
    		return 'type:'.$type;
    	});
```
![](https://www-kodphp-cn.oss-cn-beijing.aliyuncs.com/WX20191226-144502.png)

# 分包
如果我们想一个控制器配置多个同类型请求，我们可以使用分包功能。

### 根据业务类型分包
比如我们想把文章列表的api，和文章详情的api，都指向同一个php文件，路由可以这样配置
```shell
/article
    /list           /article.php            list
    /detail/(\S+)   /article.php?id=$1      detail
```
注意配置文件每一行在指向文件后面，还有一个参数`list`和`detail`。

这时候截获器restApi::get，可以添加参数来做区分，只截获对应的配置。
```php
// 捕获/article/list的get请求
restApi::get('list')
	->run(function(){
		return array('result'=>'hello list');
	});
// 捕获/article/list/29110 的get请求
restApi::get('detail')
	->run(function(int db){
		return array('result'=>'hello detail'.db);
	});
```
遇到的第一个匹配的为准，将不再试图匹配后面的条件。如果都没有匹配，返回404错误。


### 根据参数分包
```shell
/article
    /detail/type/(\S+)     /article.php?type=$1
```
上面的网址会产生一个type参数。我们可以根据type的值来做分别处理

```php
// 捕获 /article/detail/type/mdd 的get请求
restApi::get(array('type'=>'mdd'))
	->run(function(){
		return 'mdd list';
	});
// 捕获 /article/detail/type/area 的get请求
restApi::get(array('type'=>'area'))
	->run(function(int db){
		return 'area list';
	});
```
可以添加多个条件
```php
// 捕获参数 type=mdd ，且 year=2019 的请求
restApi::get(array('type'=>'mdd','year'=>2019))
	->run(function(){
		return 'mdd list';
	});
```


# 中间件扩展
系统的截获器，实现上是一个管道，默认情况下
系统有get/post/put/delete截获器、run参数处理、fetch渲染页面，三种管道。
链式调用每一步都接收上一步的数据，可以对数据进行加工，然后把数据传入下一个步骤。
我们可以通过给`restApi`扩展方法，增加自定义管道，来实现中间件。

比如我们想要实现这样的效果
```php
restApi::get(array('type'=>'list'))
	->isLogin()
	->run(function(){
		return $this->user;
	})
```
我们将展示扩展一个isLogin步骤，判断用户是否登陆。如果没有登陆，http设置400错误，如果登陆，对接收上一步`restApi::get`传过来的$data基础上，添加一个user用户信息，然后传给下一步骤。


```php
class restApi extends kod_web_restApi
{
    public function isLogin()
    {
        $this->step(function ($data) {
            /*对数据进行加工*/
            return $data;
        });
        return self::getinstance();
    }
}
```
完整的实现如下

```php
class restApi extends kod_web_restApi
{
    public function isLogin()
    {
        $this->step(function ($data) {
            $token = $_SERVER['HTTP_TOKEN'];
            if ($token) {
                list($email, $token) = explode('@@', $token);
                if ($token === kod_db_memcache::get('user::token::' . $email)) {
                    $this->user = current(user::create()->getList(array(
                        'account' => $email
                    )));
                    return $data;
                } else {
                    httpError::set(401, '必须登陆');
                }
            } else {
                list($email, $token) = explode('@@', $_SERVER['HTTP_TOKEN']);
                if ($email === kod_db_memcache::get('token::user' . $token)) {
                    return $data;
                } else {
                    httpError::set(401, '必须登陆');
                }
            }
        });
        return self::getinstance();
    }
}
```
## 优秀实践
对比其他的php框架，以管道的方式实现中间件有很多优势，可以在各个环节添加管道，以便实现更加配置化的功能。
以之前开发的一个网站举例，其中一个业务代码如下：
```php
restApi::get()
    ->mobileTurn(function (int $id) {
        return 'http://m.5fen.com/mdd/'.$id;
    })
    ->run(function (int $id) {
        $mddInfo = mdd::create()->getByKeys($id);
        return array(
            'mddInfo' => $mddInfo,
        );
    })
    ->tdk(function ($data) {
        return array(
            'title' => '【五分旅游】旅行自由行攻略,下一站去哪儿寻找旅行灵感网站,'.$data['name'].'旅游攻略',
            'description' => '下一站的旅行，去哪儿，在五分旅游可以找到好玩儿，新鲜，有趣，景好人少的目的地景点，无论大众还是小众旅游出行，海量旅行自由行攻略，都可帮您寻找下一站旅游灵感。五分旅游，简单您的旅行。',
            'keywords' => '五分旅游,旅游攻略,自由行'
        );
    })
    ->setNav('mdd')
    ->fetch('mdd/index.tpl');
```
增加的截获器有
<table>
    <thead>
        <tr>
            <td>管道</td>
            <td>功能</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>mobileTurn</td>
            <td>如果是手机登陆，301到某个地址</td>
        </tr>
        <tr>
            <td>tdk</td>
            <td>根据获取的$data，添加页面title、description、keywords</td>
        </tr>
        <tr>
            <td>setNav</td>
            <td>设置导航current定位</td>
        </tr>
    </tbody>
</table>


kod项目也自带了一个优秀案例，供你参考

[https://github.com/13601313270/kod/blob/master/demo/restApiDemo.php](https://github.com/13601313270/kod/blob/master/demo/restApiDemo.php)

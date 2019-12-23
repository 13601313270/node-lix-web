系统有一个专门做路由截获判断的类，也常搭配路由分发类```kod_web_rewrite```使用，起到更方便的路由分发和截获。
`kod_web_restApi`是个抽象类，我们需要继承出一个实体类才可以使用，系统初始化的时候，就在/include/restApi创建了一个这样的类。这个类将来还要扩展很多方法，实现中间件，实现更方便的路由
```php
class restApi extends kod_web_restApi
{
}
```

## 使用

```php
// 注册三个捕获事件
restApi::get(array('type'=>'list'))
	->run(function(){
		return array('result'=>1);
	})
restApi::get(array('type'=>'detail'))
	->run(function(){
		return array('result'=>2);
	})
restApi::get()
	->run(function(){
		return array('result'=>3);
	})
// 执行事件
restApi::getInstance()->lastExit();
```
上面两句都是注册捕获的get事件，使用restApi::get即可，当然也可以捕获post,put,delete事件restApi::post、restApi::put、restApi::delete，捕获其他类型的http请求。
get请求可以不加参数，那么说明只要是get请求就能捕获，如果加了参数，例如array('type'=>'list')，那么意味着$_GET['type']==='list'才能被捕获。如果一条都没有匹配中，系统将返回404错误

系统匹配了一条条件，将不再试图匹配后面的条件。所以，要注意注册事件的顺序。

->run函数是结束运算，里面有个闭包函数，然后返回值，就是http最终返回给前端的输出值。闭包函数的参数，就意味着请求必须带着的参数

```php
restApi::get(array('action'=>'list'))
	->run(function(int $type){
		return array('result'=>1);
	})
```
这时候如果我们请求
http://XXXX.com/?action=list，命中这个文件，因为闭包函数里有一个参数$type，我们网址中没有传递，那么就会爆一个400错误，并且提示您没有传递type参数。如果是截获的post/put/delete请求，就是判断post/put/delete里面有没有对应数据。
![](https://yingshijiaoyuimg.oss-cn-beijing.aliyuncs.com/WeChat932fd7592def7bfbde5f360da7fe8a52.png)

```php
restApi::get(array('action'=>'list'))
	->run(function(int $type=2){
		return array('result'=>1);
	})
```
当然我们可以个给闭包函数的参数type添加默认值，这时网址中如果缺少这个数据，就不会400缺少子段错误，而是使用默认值。

## 步骤扩展
我们可以方便的对路由截获增加步骤扩展，
以刚才的demo为例，绑定了第一步的get截获，和run执行步骤，也都是通过相同的系统步骤扩展方式扩展的，每一步都接收一个数据，可以对数据进行加工，然后传入下一个步骤。
get截获步骤传入空数据，加工添加了$_GET数据，然后传入下一步，也就是run这一步，run根据获取的$_GET，匹配闭包函数并执行。

所有中间步骤，都是可以链式调用的，下面我们将展示扩展一个isLogin步骤，判断用户是否登陆。如果没有登陆，http设置400错误，如果登陆，对接收上一步传过来的$data，添加一个userInfo用户信息，然后传给下一步骤

```php
// 我们希望达到的效果
restApi::get(array('type'=>'list'))
	->isLogin()
	->run(function($userInfo){
		return $userInfo;
	})
class restApi extends kod_web_restApi
{
    public function isLogin()
    {
        // 重要的是这里，注册步骤
        $this->step(function ($data) {
            // 模拟了一个根据cookie里的token就能获取用户信息的接口
            $loginUser = user::create()->getLoginUser($_COOKIE['token']);
            if ($loginUser) {
                $data['userInfo'] = $loginUser;    // 加工上一步传来的data，添加userInfo子段
                return $data;                      // 通过闭包函数return值，传给下一步骤
            } else {
                header('HTTP/1.1 401 Unauthorized');
                exit;
            }
        });
        // 固定格式，返回this，以便链式调用
        return self::getinstance();
    }
}
```

搭配路由分发kod_web_rewrite类，可以实现更好的分组效果。

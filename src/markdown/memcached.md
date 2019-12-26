memcache方法在网址  http://php.net/manual/zh/book.memcache.php  中查看

快速调取释放类型，每一次都链接，并且断开

## 读取
```php
kod_db_memcache::set('test',array(
	'obej'=>1,
	'hehe'=>array(1,2,3,5),
),0,20);
```

```php
print_r(kod_db_memcache::get('test'));
```

## 锁请求
```php
$data = 'hehe';
echo kod_db_memcache::returnCacheOrSave('test',function() use($data){
	return $data;
},0,10);
```
如果没有缓存，则进入绑定函数，运行的返回值进行缓存

##自增服务
`kod_db_memcache::adding(key,step,callback,callStep)`

```php
//demo
$liuxueApi = new liuxueNews();
$articleInfo = $liuxueApi->getByKey($articleId);
$articlePv = kod_db_memcache::adding('articlePv:'.$articleId,1,function($val) use($articleInfo,$liuxueApi,$articleId){
	//执行完之后$val归零
	$liuxueApi->update('id='.$articleId,array(
		'look'=>intval($articleInfo['look'])+intval($val)
	));
},10);
```
上面这个demo，是对每一个文章进行pv统计，每次+1，每10次，执行一次存库操作



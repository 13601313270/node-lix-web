memcache方法在网址  http://php.net/manual/zh/book.memcache.php  中查看

快速调取释放类型，每一次都链接，并且断开

```php
kod_db_memcache::set('test',array(
	'obej'=>1,
	'hehe'=>array(1,2,3,5),
),0,20);
```

```php
print_r(kod_db_memcache::get('test'));
```

```php
$data = 'hehe';
echo kod_db_memcache::returnCacheOrSave('test',function() use($data){
	return $data;
},0,10);
```

##自增服务
```php
public static function adding($key,$numAdd,$function,$step=0){
	$value = kod_db_memcache::get($key);
	if($value==false){
		kod_db_memcache::set($key,$numAdd);
	}else{
		kod_db_memcache::increment($key,$numAdd);
	}
	$value = kod_db_memcache::get($key);
	if($step && $value%$step==0){
		$function($value);
		kod_db_memcache::set($key,0);
	}
	return $value;
}
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


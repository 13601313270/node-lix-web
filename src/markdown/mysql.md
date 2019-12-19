# kod\_db\_mysqlTable
这是一个针对单表的操作类，封装了很多针对单表的操作，让你摆脱书写sql语句。同时通过配置表之间的联系，如join和外键，你可以方便的快速扩展数据，而不用自己拼装。

## 初始化
首先你得有一张mysql的表，下面例子中我们有了一张名叫`user`的表。定义一个继承`kod_db_mysqlTable`的子类。然后定义`dbName`、`tableName`、`key`、`keyDataType`四个属性，分别代表:数据库、表名、主键字段和主键类型。
> 四个属性推荐使用`protected `类型的

```php
class user extends kod_db_mysqlTable {
    protected $dbName = 'content';	//数据库
    protected $tableName = 'user';	//数据表
    protected $key = 'id';		//主键(设置的话可以提供一些快捷方法)
    protected $keyDataType = 'int';	//主键数据类型(主键的数据类型int varchar)
}
```

一个最基本的单表user表的操作类就完成了。接下来我们就可以使用它了。我们先进行一个简单的查询。

```php
$userData = user::create()
    ->where(array(
        'type' => 1,
        'status' => 0
    ))
    ->limit(5)
    ->get();
```

采用链式操作，where和limit是过程方法，get方法是结束方法。
过程方法添加sql拼接条件，最终在get结束符查询数据。`kod_db_mysqlTable`使用过程中，在结束符调用之前，可以添加任意数量的过程方法。

这个例子等价于进行了这个sql查询
```sql
select * from content.user where type=1 and status=0 limit 5
```

系统封装了很多过程方法和很多结束方法，可以很方便的帮助您拼接sql。

## where
用来拼接sql中的where条件
```php
user::create()
->where(array(
'type' => 1,
'status' => 0
))
->get();
//select * from content.user where type=1 and status=0
```
数组对应代表的是=操作，当然也可以直接在key里面使用  !=  >  <  >= <= in like，等操作符即可
```php
user::create()
->where(array(
"ctime>=" => "2018",
"status!=" => 0,
"type in"=>array(1,2)
))
->get();
//select * from content.user where ctime>='2018' and status!=0 and type in (1,2)
```
如果条件之间有复杂的or和and逻辑，可以这样设置
```php
user::create()->where(
kod_and(
array('status' => 1),
kod_or(
array(
'name'       => 'whr',
'alias_name' => 'whr',
)
)
)
)
//where status=1 and (name='whr' or alias_name='whr')
```
如果where条件比较复杂，可以直接传入字符串即可
```php
user::create()
->where("ctime>=2018 and status!=type")
->get();
//select * from content.user where ctime>=2018 and status!=type
```
## select
用来拼接sql中的select
```php
user::create()
->select('id,name,age')
->where("ctime>=2018 and status!=type")
->get();
//select id,name,age from content.user where ctime>=2018 and status!=type
```
也可以传入数组
```php
user::create()
->select(array('id','name','age'))
->where("ctime>=2018 and status!=type")
->get();
//两种方法等价
```
## limit
用来拼接sql中的limit

```php
user::create()
->where("status=2")
->limit(5)
->get();
//select * from content.user where status=2 limit 5
user::create()->where("status=2")->limit(5,10)->get();
//select * from content.user where status=2 limit 5,10
```

limit可以添加一个或两个参数，对应sql的一个或两个参数

## orderBy

```php
user::create()
->where("status=2")
->limit(5,10)
->orderBy('id')
->get();
//select * from content.user where status=2 order by id limit 5,10
```
```php
user::create()
->where("status=2")
->limit(5,10)
->orderBy('id desc')
->get();
//select * from content.user where status=2 order by id desc limit 5,10
```

## groupBy
```php
user::create()
->orderBy('id')
->groupBy('type')
->where("status=2")
->get();
//select * from content.user where status=2 group by type order by id
```

>链式调用的顺序，不影响最后sql拼接的顺序

## join
实现sql的join方法，需要在类里定义关联子段
```php
class user extends kod_db_mysqlTable{
    protected $dbName = 'content';	//数据库
    protected $tableName = 'user';	//数据表
    protected $key = 'id';		//主键(设置的话可以提供一些快捷方法)
    protected $keyDataType = 'int';	//主键数据类型(主键的数据类型int varchar)
    protected $joinList = array(
        'user_info' => array(
            'id' => 'info_id'	//user表连接user_info的时候，连接条件是 user.id 等于 user_info.info_id
        )
    );
}
user::create()->join('user_info','name,phone')
// select user.*,user_info.name,user_info,phone from user join user_info on user.id=user_info.info_id
//第一个参数是要连接的表，user表连接了user_info表
//第二个参数是被连接的表，都有哪些子段加入结果
```
除了`join`还有`leftJoin`和`fullJoin`，用法相似。

除了官方自带的过程运算方式，还可以自己扩展过程运算，向select, join, sql, afterSql, data，这几个钩子添加运算。下面讲一下结束符
## get【结束符】
获取数据，以array的形式返回
```php
user::create()
->orderBy('id')
->groupBy('type')
->where("status=2")
->get();
```
## exist【结束符】
查询设置的条件是否能查出值，返回boolean值。
```php
user::create()
->orderBy('id')
->groupBy('type')
->where("status=2")
->exist();
```
## count【结束符】
查询设置的条件满足的记录书，返回数值。
```php
user::create()
->orderBy('id')
->groupBy('type')
->where("status=2")
->count();
```

## getByKey【结束符】
根据设置的主键，获取单条记录。使用此结束符，自动忽略where、group、order。
```php
user::create()
->select('name,title')
->getByKey(203);	//获取主键为203的记录
```
## first【结束符】
跟get相比，只返回get结果的第一条。如果调用时带参数first(column)，那么返回第一条结果的某个参数
```php
user::create()
->orderBy('id')
->groupBy('type')
->where("status=2")
->first();
//返回第一项数据
```
```php
user::create()
->orderBy('id')
->groupBy('type')
->where("status=2")
->first('name');
//返回第一项数据的name子段的值
```

# insert
# update
# 子查询

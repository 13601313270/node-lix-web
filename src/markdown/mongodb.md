# kod\_db\_mysqlTable
这是一个针对单表的操作类，封装了很多针对单表的操作，让你摆脱书写sql语句。同时通过配置表之间的联系，如join和外键，你可以方便的快速扩展数据，而不用自己拼装。

## 初始化
首先你需要在根目录的 include.php 设置三个全局变量：

地址：```KOD_MONGODB_HOST```

账号：```KOD_MONGODB_USER```

密码：```KOD_MONGODB_PASSWORD```

就像下面这样
```php
define("KOD_MONGODB_HOST", "dds-2zef5960fed0f8f41813-pub.mongodb.rds.aliyuncs.com:3717,dds-2zef5960fed0f8f42943-pub.mongodb.rds.aliyuncs.com:3717/admin?replicaSet=mgset-5320935");
define("KOD_MONGODB_USER", "root");
define("KOD_MONGODB_PASSWORD", "WwEDYb3!TrvUqWUE");
```


## 定义model类
首先你得有一张mysql的表，下面例子中我们有了一张名叫`guide`的表。定义一个继承`kod_db_mongoDB`的子类。然后定义`dbName`、`tableName`、`key`、`keyDataType`四个属性，分别代表:数据库、表名、主键字段和主键类型。
> 四个属性推荐使用`protected `类型的

```php
class guide extends kod_db_mongoDB
{
	//数据库
    protected $dbName = 'new-5fen-base';
    //集合
    protected $tableName = 'guide';
    //主键(设置的话可以提供一些快捷方法)
    protected $key = 'auto_increatement_id';
    //主键数据类型(主键的数据类型int varchar)
    protected $keyDataType = 'int';
}
```

一个最基本的单表guide集合的操作类就完成了。接下来我们就可以使用它了。我们先进行一个简单的查询。

```php
$articles = guide::create()
                ->select('title,auto_increatement_id,ctime,views,contents')
                ->where(array(
                    'mdds_id' => $guide['mdds_id'][0]
                ))
                ->limit(33)
                ->sort('ctime')
                ->get();
```

采用链式操作，where和limit是过程方法，get方法是结束方法。
过程方法添加sql拼接条件，最终在get结束符查询数据。`kod_db_mongoDB`使用过程中，在结束符调用之前，可以添加任意数量的过程方法。


系统封装了很多过程方法和很多结束方法，可以很方便的帮助您拼接sql。

## where
用来拼接sql中的where条件，具体的规则按照mongodb的find查询语句的规范，参考
https://www.runoob.com/mongodb/mongodb-query.html
例如：
```php
$aMdds = mdd::create()
    ->where(array(
        'name_cn' => array('$in' =>
            ['三亚', '成都', '北京', '哈尔滨', '上海', '杭州', '香港', '西安', '苏州', '重庆', '东京', '拉萨', '青岛', '大理', '南京', '昆明', '台北', '清迈']
        )
    ))->get();
```

有一些常用的mongodb查询方法
<table>
    <thead>
        <tr>
            <td>操作</td>
            <td>格式</td>
            <td>范例</td>
            <td>RDBMS中的类似语句</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>等于</td>
            <td>{key:value}</td>
            <td>db.col.find({"by":"菜鸟教程"}).pretty()</td>
            <td>where by = '菜鸟教程'</td>
        </tr>
        <tr>
            <td>小于</td>
            <td>{key:{$lt:value}}</td>
            <td>db.col.find({"likes":{$lt:50}}).pretty()</td>
            <td>where likes < 50</td>
        </tr>
        <tr>
            <td>小于或等于</td>
            <td>{key:{$lte:value}}</td>
            <td>db.col.find({"likes":{$lte:50}}).pretty()</td>
            <td>where likes <= 50</td>
        </tr>
        <tr>
            <td>大于</td>
            <td>{key:{$gt:value}}</td>
            <td>db.col.find({"likes":{$gt:50}}).pretty()</td>
            <td>where likes > 50</td>
        </tr>
        <tr>
            <td>大于或等于</td>
            <td>{key:{$gte:value}}</td>
            <td>db.col.find({"likes":{$gte:50}}).pretty()</td>
            <td>where likes >= 50</td>
        </tr>
        <tr>
            <td>不等于</td>
            <td>{key:{$ne:value}}</td>
            <td>db.col.find({"likes":{$ne:50}}).pretty()</td>
            <td>where likes != 50</td>
        </tr>
    </tbody>
</table>

## select
设置要取回的字段，不填写默认返回所有，但是按需获取或减轻数据库的压力。
```php
user::create()
->select('id,name,age')
->where("ctime>=2018 and status!=type")
->get();
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
设置需要的数据量

只传递一个参数，代表只取前面若干数据
```php
user::create()
    ->where("status=2")
    ->limit(5)
    ->get();
    // 只取前5条数据
```
传递两个参数，第一个参数截取开始序列，第二个参数是要获取的数量
```php
user::create()
    ->where("status=2")
    ->limit(5,10)
    ->get();
    // 取从第5条数据开始后面的10条数据
```

limit可以添加一个或两个参数，对应sql的一个或两个参数

## sort
排序
下面的例子是score从大到小
```php
user::create()
->where("status=2")
->limit(5,10)
->sort('score')
->get();
```
第二个参数默认是-1从大到小，如果需要指定从小到大，可以传递1。下面的例子是score从小到大
```php
user::create()
->where("status=2")
->limit(5,10)
->sort('score',1)
->get();
```

!!目前有一些问题
## groupBy
```php

```


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

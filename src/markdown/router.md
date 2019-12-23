kod系统默认的路由方式是参考apache的正则匹配方式，因为正则书写门槛最低。

写过apache路由的人，一定熟悉下面这个写法，这是一个简单的rewrite配置的例子
```shell
/sales/(\d+).html       /sales/info.php?id=$1
/sales/ota/(\d+).html   /sales/ota.php?id=$1
/sales/(\d+)-(\d+)-(\d+)-(\d+).html?(.*)    /sales/?date=$1&from=$2&to=$3&type=$4&$5
/photo/(\d+)/scenery_(\d+)_(\d+).html       /mdd/plistdetail.php?mddid=$1&topiid=$2&page=$3&static_url=1
/photo/(\d+)/scenery_(\d+)/(\d+).html       /mdd/pdetail.php?mddid=$1&topiid=$2&pid=$3
/photo/poi/(\d+).html           /album/poi-album.php?id=$1
/photo/poi/(\d+)_(\d+).html     /album/photoDetail.php?poiid=$1&id=$2
/photo/mdd/(\d+)_(\d+).html     /album/mddPicDetail.php?mddid=$1&id=$2
/photo/mdd/(\d+).html           /album/mdd-album.php?mddid=$1
/poi/(\d+).html         /mdd/poi.php?id=$1
/poi/map_(\d+).html     /mdd/poi_map.php?poiid=$1
/poi/intro_(\d+).html   /mdd/poi.php/intro/?id=$1
/poi/guide_(\d+).html   /mdd/poi.php/guide/?id=$1
/poi/comment_(\d+).html /mdd/poi.php/comment/?id=$1
```

kod默认路由功能，支持一种层级表达式的书写方式，可以把这些路由编写成带有层级的形式。四个空格或者一个Tab一个锁进级别。我们可以把路由配置简化成下面这样。配置文件路径就是根目录的 rewrite.conf
```shell
/sales
    /(\d+).html         /sales/info.php?id=$1
    /ota/(\d+).html     /sales/ota.php?id=$1
    /(\d+)-(\d+)-(\d+)-(\d+).html?(.*) /sales/?date=$1&from=$2&to=$3&type=$4&$5
/photo
    /(\d+)/scenery_(\d+)_(\d+).html     /mdd/plistdetail.php?mddid=$1&topiid=$2&page=$3&static_url=1
    /(\d+)/scenery_(\d+)/(\d+).html     /mdd/pdetail.php?mddid=$1&topiid=$2&pid=$3
    /poi
        /(\d+).html         /album/poi-album.php?id=$1
        /(\d+)_(\d+).html   /album/photoDetail.php?poiid=$1&id=$2
    /mdd
        /(\d+)_(\d+).html   /album/mddPicDetail.php?mddid=$1&id=$2
        /(\d+).html         /album/mdd-album.php?mddid=$1
/poi
    /(\d+).html         /mdd/poi.php?id=$1
    /map_(\d+).html     /mdd/poi_map.php?poiid=$1
    /intro_(\d+).html   /mdd/poi.php/intro/?id=$1
    /guide_(\d+).html   /mdd/poi.php/guide/?id=$1
    /comment_(\d+).html /mdd/poi.php/comment/?id=$1
```
左侧代表的是浏览器输入的网址，右侧代表的是根目录src下的php文件。
以上面的配置举例子，如果用户浏览器输入的/sales/123.html，则会被指向到 网站根目录/src/sales/info.php
（src是项目生成时设置的webDIR，如果设置不是默认值，则把src进行替换即可）

你可以自己指定路由配置文件规则，官方也附带了3中最常用的形式，但是我们还是推荐使用层级表达式的格式，apache\json\层级表达式
如果只是一个静态页面，没有php业务逻辑，也可以直接指向tpl文件

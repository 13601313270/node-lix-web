{extends file="./template.tpl"}
{block name="container"}
    如果只是一个静态页面，没有php业务逻辑，也可以直接指向tpl文件

    你可以自己指定路由配置文件规则，官方也附带了3中最常用的形式，但是我们还是推荐使用层级表达式的格式，apache\json\层级表达式

    /sales
        /(\d+).html /sales/info.php?id=$1
        /ota/(\d+).html /sales/ota.php?id=$1
        /(\d+)-(\d+)-(\d+)-(\d+).html?(.*) /sales/?date=$1&from=$2&to=$3&type=$4&$5
    /photo
        /(\d+)/scenery_(\d+)_(\d+).html /mdd/plistdetail.php?mddid=$1&topiid=$2&page=$3&static_url=1
        /(\d+)/scenery_(\d+)/(\d+).html /mdd/pdetail.php?mddid=$1&topiid=$2&pid=$3
        /poi
            /(\d+).html /album/poi-album.php?id=$1
            /(\d+)_(\d+).html /album/photoDetail.php?poiid=$1&id=$2
        /mdd
            /(\d+)_(\d+).html /album/mddPicDetail.php?mddid=$1&id=$2
            /(\d+).html /album/mdd-album.php?mddid=$1
    /poi
        /(\d+).html /mdd/poi.php?id=$1
        /map_(\d+).html /mdd/poi_map.php?poiid=$1
        /intro_(\d+).html /mdd/poi.php/intro/?id=$1
        /guide_(\d+).html /mdd/poi.php/guide/?id=$1
        /comment_(\d+).html /mdd/poi.php/comment/?id=$1
{/block}

<?php

ini_set('display_errors',1);
error_reporting(E_ALL^E_NOTICE);
date_default_timezone_set('PRC');
define("webDIR",dirname(__FILE__)."/src/");
define("KOD_SMARTY_COMPILR_DIR",dirname(__FILE__).'/smarty_cache');
define("KOD_MYSQL_SERVER",'*****');
define("KOD_MYSQL_USER",'root');
define("KOD_MYSQL_PASSWORD",'*****');
define("KOD_COMMENT_MYSQLDB",'test');
define("KOD_MEMCACHE_OPEN",true);
define("KOD_MEMCACHE_TYPE",KOD_MEMCACHE_TYPE_MEMCACHED);
define("KOD_MEMCACHE_HOST","localhost");
define("KOD_MEMCACHE_PORT","11211");
include_once(dirname(__FILE__).'/kod/include.php');
function kod_ControlAutoLoad($model){
    $classAutoLoad=array();
    if(isset($classAutoLoad[$model])){
        include_once($classAutoLoad[$model]);
    }
    elseif(strpos($model,'kod_')===false&&strpos($model,'Smarty_')===false){
        if(is_file(__DIR__.'/include/'.$model.'.php')){
            include_once(__DIR__.'/include/'.$model.'.php');
        }
    }
}

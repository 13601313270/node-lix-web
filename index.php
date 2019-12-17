<?php

include_once("include.php");
kod_web_rewrite::init(dirname(__FILE__)."/rewrite.conf");
$result=kod_web_rewrite::getPathByUrl(current(explode("?",$_SERVER["REQUEST_URI"])));
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials:true");
header("Access-Control-Allow-Methods:OPTIONS, GET, POST, PUT, DELETE");
if($_SERVER["REQUEST_METHOD"]==="OPTIONS"){
    header("Access-Control-Allow-Headers:Content-Type,XFILENAME,XFILECATEGORY,XFILESIZE");
    exit;
}
if(empty(!$result)){
    $new=parse_url($result[1]);
    parse_str($new["query"],$myArray);
    $_GET=array_merge($_GET,$myArray);
    $_SERVER["SCRIPT_URL"]=$new["path"];
    $_SERVER["SCRIPT_URI"]=$_SERVER["REQUEST_SCHEME"]."://";
    if(!empty($new["query"])){
        $_SERVER["REQUEST_URI"]=$new["path"]."?";
    }
    else{
        $_SERVER["REQUEST_URI"]=$new["path"];
    }
    $_SERVER["SCRIPT_FILENAME"]=$new["path"];
    $_SERVER["SCRIPT_NAME"]=$new["path"];
    $_SERVER["PHP_SELF"]=$new["path"];
    unset($new);
    chdir("./src/");
    if (substr($result[1], -4) === '.tpl') {
        $page = new kod_web_page();
        $page->fetch("." . $result[1]);
        exit;
    }
    else if(substr($_SERVER["SCRIPT_FILENAME"],strlen($_SERVER["SCRIPT_FILENAME"]))){
        include_once($_SERVER["SCRIPT_FILENAME"]."index.php");
    }
    else{
        if(substr($_SERVER["SCRIPT_FILENAME"],0,1)==="/"){
            include_once(".".$_SERVER["SCRIPT_FILENAME"]);
        }
        else{
            include_once($_SERVER["SCRIPT_FILENAME"]);
        }
    }
    if(isset($result[2])){
        restApi::getinstance($result[2])->lastExit();
    }
    else{
        restApi::getinstance()->lastExit();
    }
    unset($result);
}
else{
    header("HTTP/1.1 404 Not Found");
    echo("404");
    exit;
}

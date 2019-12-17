{extends file="./template.tpl"}
{block name="container"}
    style自动提取，需要设置两个配置

    define("KOD_SMARTY_CSS_DIR", dirname(__FILE__) . '/style_cache/');
    define("KOD_SMARTY_CSS_HOST", '/style/');

    需要服务器上实现重定向，例如apache可以写
    RewriteRule ^/style/(.*).css$ /style_cache/$1.css [L]
{/block}

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="renderer" content="webkit">
    <link rel="shortcut icon" href="https://www-kodphp-cn.oss-cn-beijing.aliyuncs.com/bitbug_favicon.ico">
    {if !empty($__kodStepTdk__)}
        <title>{$__kodStepTdk__.title}</title>
        <meta name="keywords" content="{$__kodStepTdk__.keywords}"/>
        <meta name="description" content="{$__kodStepTdk__.description}"/>
    {/if}
</head>
<body>
<div class="header">
    <div class="container">
        <img class="icon"
             src="http://yingshijiaoyuimg.oss-cn-beijing.aliyuncs.com/56363204ba30dc796b23658faee951c8.png">
        <div style="color: #986847;font-size: 28px;padding-left: 10px;">kod</div>
        <div class="links" style="flex-grow: 1;display: flex;justify-content: flex-end;">
            <a href="https://github.com/13601313270/kod" target="_blank">kod源码</a>
            <a href="https://github.com/13601313270/kodphp_web" target="_blank">此网站源码</a>
        </div>
    </div>
</div>
<div class="content">
    <div class="left_content">
        {include file="nav.tpl"}
    </div>
    <div class="right_content">
        {block name="container"}{/block}
    </div>
</div>
<footer>
    <div>
        网站备案：京ICP备17039360号-3
    </div>
</footer>
<style>
    body {
        margin: 0;
        padding: 0;
    }

    .header {
        position: fixed;
        height: 80px;
        top: 0;
        left: 0;
        right: 0;
        background: white;
        z-index: 9999;
    }

    .header .container {
        width: 1140px;
        padding: 0;
        margin: 0 auto;
        display: flex;
        flex-direction: row;
        border-bottom: solid 1px #d0d0d4;
        height: 100%;
        align-items: center;
    }

    .header .container .links > * {
        padding: 0 10px;
        color: #313131;
    }

    .content {
        width: 1140px;
        padding-top: 20px;
        margin: 80px auto;
    }

    .left_content {
        width: 200px;
        flex-shrink: 0;
        /*background: #d0d0d4;*/
        position: fixed;
        top: 100px;
        z-index: 1;
        bottom: 0;
        height: 100%;
    }

    .left_content a {
        display: block;
    }

    .right_content {
        width: 100%;
        padding-left: 250px;
        box-sizing: border-box;
    }

    .right_content h1 {
        margin: 0 0 10px;
    }

    .right_content p {
        margin: 0 0 10px;
    }

    .icon {
        height: 60px;
    }

    footer {
        color: #9c9c9c;
        background: #f4f4f4;
        padding: 10px 0;
    }

    footer > div {
        width: 1140px;
        margin: 0 auto;
    }
</style>
<style lang="less">
    code {
        background: #4f4f4f;
        color: #eaeaea;
        position: relative;
        vertical-align: unset;
        font-family: Consolas, Monaco, "Andale Mono", "Ubuntu Mono", monospace;
        font-size: 1em;
        text-align: left;
        white-space: pre;
        word-spacing: normal;
        word-break: normal;
        word-wrap: normal;
        line-height: 1.5;
        padding: 3px;
        margin: 0 3px;
        border-radius: 5px;
        overflow-x: auto;
        .key_words {
            color: #cc7832;
        }
        .class_property {
            color: #9876aa;
        }
        .variable {
            color: #9876aa;
        }
    }
    table {
        border-spacing: 0;
        border-top: solid 1px #c5c5c5;
        border-left: solid 1px #c5c5c5;
        tr td {
            border-bottom: solid 1px #c5c5c5;
            border-right: solid 1px #c5c5c5;
            padding: 5px;
        }
    }

    .php_code {
        background: #1f1f1f;
        color: #ccc;
        display: block;
        padding: 5px 8px;
        margin: 5px 0;
    }

    .shell_code {
        background: #1f1f1f;
        color: #ccc;
        display: block;
        padding: 5px 8px;
        margin: 5px 0;
    }

    code .class_property_call {
        color: #ffc66d;
    }

    code .function_declara {
        color: #ffc66d;
    }

    code .comment {
        color: grey;
    }

    code .string {
        color: #6ab759;
    }

    code .number {
        color: #6897bb;
    }
    .right_content {
        img {
            max-width: 100%;
        }
    }

    .right_content h1 {
        color: #3b3b3b;
        font-size: 26px;
        font-weight: bold;
    }

    .right_content h2 {
        color: #3b3b3b;
        font-size: 20px;
        font-weight: bold;
    }

    .right_content h3 {
        color: #3b3b3b;
        font-size: 16px;
        font-weight: bold;
    }

    .right_content p {
        color: #3b3b3b;
        font-size: 14px;
    }

    .right_content img {
        border: solid 1px #d8d8d8;
    }
</style>
</body>
{*{include file="../kod/web/hotModule/hotModule.tpl"}*}
</html>

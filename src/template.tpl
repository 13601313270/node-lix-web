<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="renderer" content="webkit">
    {if !empty($__kodStepTdk__)}
        <title>{$__kodStepTdk__.title}</title>
        <meta name="keywords" content="{$__kodStepTdk__.keywords}"/>
        <meta name="description" content="{$__kodStepTdk__.description}"/>
    {/if}
</head>
<body>
<div class="content">
    <div class="left_content">
        {include file="nav.tpl"}
    </div>
    <div class="right_content">
        {block name="container"}{/block}
    </div>
</div>
<style>
    body {
        margin: 0;
        padding: 0;
    }

    .content {
        display: flex;
        flex-direction: row;
    }

    .left_content {
        width: 310px;
        padding-left: 30px;
        flex-shrink: 0;
        background: #d0d0d4;
    }

    .left_content a {
        display: block;
    }

    .right_content {
        flex-grow: 1;
        padding: 10px;
    }
</style>
</body>
{*{include file="../kod/web/hotModule/hotModule.tpl"}*}
</html>

<?php
restApi::get()->run(function () {
    return array(
        'title' => 'hello kod\'s world',
        'content' => 'welcome to hear'
    );
})->fetch('index.tpl');

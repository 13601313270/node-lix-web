<?php

use Michelf\Markdown, Michelf\SmartyPants;

function smarty_function_markdown($params, $template)
{
    return Markdown::defaultTransform(file_get_contents(webDIR . 'markdown/' . $params['file']));
}

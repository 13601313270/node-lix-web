<?php

use Michelf\Markdown;

include '../metaPHP/include.php';//引入metaPHP
use metaPHP\phpInterpreter;

class newMark extends Markdown
{
    protected function makeCodeSpan($code)
    {
        if (substr($code, 0, 4) === "php\n") {
            $metaApi = new phpInterpreter('<?php ' . substr($code, 4));
            return $this->hashPart("<code class='php_code'>" . substr($metaApi->getHtml(), 6) . "</code>");
        } elseif (substr($code, 0, 4) === "sql\n") {
            return $this->hashPart("<code class='sql_code'>" . substr($code, 4) . "</code>");
        } elseif (substr($code, 0, 6) === "shell\n") {
            return $this->hashPart("<code class='shell_code'>" . substr($code, 6) . "</code>");
        } elseif (substr($code, 0, 6) === "html\n") {
            return $this->hashPart("<code class='html'>" . substr($code, 5) . "</code>");
        } else {
            return $this->hashPart("<code>" . preg_replace('/^\n/', '', $code) . "</code>");
        }
    }
}

function smarty_function_markdown($params, $template)
{
    return newMark::defaultTransform(file_get_contents(webDIR . 'markdown/' . $params['file']));
}

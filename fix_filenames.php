<?php
/**
 * Recursively fix files and directory names
 * php version 8.2
 *
 * @category Helper
 * @package  None
 * @author   Fred Brooker <git@gscloud.cz>
 * @license  MIT https://gscloud.cz/LICENSE
 * @link     None
 */

if (file_exists('.bashrc')) {
    die("EMERGENCY STOP!!!");
}

define("DS", DIRECTORY_SEPARATOR);

$map = [
    "'" => '',
    "┬" => '',
    "║" => '',
    ' ' => '_',
    '!' => '',
    '"' => '',
    '#' => '',
    '&' => '',
    '(' => '_',
    ')' => '_',
    '[' => '_',
    ']' => '_',
    '+' => '-',
    ',' => '',
    ';' => '_',
    '@' => '',
    '^' => '',
    '|' => '',
    '¦' => '',
    '~' => '-',

    'á' => 'a',
    'č' => 'c',
    'à' => 'a',
    'á' => 'a',
    'ä' => 'a',

    'č' => 'c',
    'ć' => 'c',

    'ď' => 'd',

    'ě' => 'e',
    'è' => 'e',
    'é' => 'e',
    'ë' => 'e',
    'é' => 'e',
    'ě' => 'e',

    'í' => 'i',
    'í' => 'i',

    'ĺ' => 'l',
    'ľ' => 'l',

    'ň' => 'n',

    'ó' => 'o',
    'ô' => 'o',
    'ö' => 'o',
    'ö' => 'o',
    'ø' => 'o',

    'ř' => 'r',
    'ŕ' => 'r',
    'ř' => 'r',

    'š' => 's',
    'š' => 's',

    'ť' => 't',

    'ú' => 'u',
    'ú' => 'u',
    'û' => 'u',
    'ü' => 'u',
    'ü' => 'u',
    'ü' => 'u',
    'ů' => 'u',

    'ý' => 'y',
    'ý' => 'y',

    'ž' => 'z',
    'ž' => 'z',

    'Á' => 'A',
    'Ä' => 'A',

    'Ć' => 'C',
    'Č' => 'C',

    'Ď' => 'D',

    'É' => 'E',
    'Ě' => 'E',

    'Í' => 'I',

    'Ĺ' => 'L',
    'Ľ' => 'l',

    'Ň' => 'N',

    'Ó' => 'O',
    'Ô' => 'o',
    'Ö' => 'O',

    'Ŕ' => 'R',
    'Ř' => 'R',

    'Š' => 'S',

    'Ť' => 'T',

    'Ü' => 'U',
    'Ü' => 'U',
    'Ú' => 'U',
    'Û' => 'U',
    'Ů' => 'U',

    'Ý' => 'Y',

    'Ž' => 'Z',

    '–' => '-',
    '—' => '-',
    '’' => '',
    '“' => '',
    '„' => '',
    '•' => '-',
    '…' => '',
    '♥' => '',
    '♫' => '',
    '⧸' => '-',
    '⧹' => '-',
    '＂' => '',
    '：' => '-',
    '？' => '',
    '｜' => '-',
    '..' => '.',
    '--' => '-',
    '__' => '_',
];

$work = true;
do {
    $i = 0;
    $dirs = [];
    $paths = [];
    $names1 = [];
    $names2 = [];
    clearstatcache();
    echo "Reading folders ...\n";

    foreach ($iterator = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator(
            "./",
            RecursiveDirectoryIterator::SKIP_DOTS
        ), RecursiveIteratorIterator::SELF_FIRST
    ) as $item) {
        $path = $iterator->getSubPath();
        $sub = $iterator->getSubPathName();
        $name = $iterator->getFileName();
        $fixname = strtolower(strtr($name, $map));
        $fixname = preg_replace('!_+!', '_', $fixname);
        $fixname = str_replace("-_", '-', $fixname);
        $fixname = str_replace(".-", '.', $fixname);
        $fixname = str_replace("._", '.', $fixname);
        $fixname = str_replace("_-", '-', $fixname);
        $fixname = str_replace("_.", '.', $fixname);
        $fixname = str_replace("_-_", '-', $fixname);
        $fixname = trim($fixname, " _-.");
        $fixname = preg_replace('!_+!', '_', $fixname);
        if ($item->isDir()) {
            if ($name != $fixname) {
                $dirs[$sub] = substr_count($sub, "/");
                $names1[$sub] = $name;
                $names2[$sub] = $fixname;
                $paths[$sub] = $path;
                echo "+";
                $i++;
            } else {
                echo ".";
            }
        }
    }
    arsort($dirs);

    if (count($dirs)) {
        $fixes = count($dirs);
        echo "\nFixing folders ($fixes) ...\n";
        $fails = 0;
        foreach ($dirs??=[] as $k => $v) {
            if ($paths[$k] == "") {
                $paths[$k] = ".";
            }
            echo "> $paths[$k]/$names2[$k]\n";
            if (!@rename("$paths[$k]/$names1[$k]", "$paths[$k]/$names2[$k]")) {
                $fails++;
                echo "\n! {$fails}. FAILED: {$paths[$k]}/{$names1[$k]}"
                    . " -> {$paths[$k]}/{$names2[$k]}\n";
            }
        }
    } else {
        $work = false;
    }
} while ($work);

echo "\nFixing files...\n";
foreach ($iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator(
        "./",
        RecursiveDirectoryIterator::SKIP_DOTS
    ), RecursiveIteratorIterator::SELF_FIRST
) as $item) {
    $path = $iterator->getSubPath();
    $sub = $iterator->getSubPathName();
    $name = $iterator->getFileName();
    $fixname = strtolower(strtr($name, $map));
    $fixname = preg_replace('!_+!', '_', $fixname);
    $fixname = str_replace("-_", '-', $fixname);
    $fixname = str_replace(".-", '.', $fixname);
    $fixname = str_replace("._", '.', $fixname);
    $fixname = str_replace("_-", '-', $fixname);
    $fixname = str_replace("_.", '.', $fixname);
    $fixname = str_replace("_-_", '-', $fixname);
    $fixname = trim($fixname, " _-.");
    $fixname = preg_replace('!_+!', '_', $fixname);
    $fixname = preg_replace('!-+!', '-', $fixname);
    $fixname = str_replace("..", '.', $fixname);
    if ($fixname == 'concat') {
        $fixname = '.concat';
    }
    if ($item->isDir()) {
        continue;
    } else {
        if (strlen($path) == 0 && $name != $fixname) {
            echo "  * $fixname\n";
            @rename($name, $fixname);
        }
        if (strlen($path) && $name != $fixname) {
            echo "  * $fixname\n";
            @rename($path . DS . $name, $path . DS . $fixname);
        }
    }
}

echo "\nDone.\n\n";

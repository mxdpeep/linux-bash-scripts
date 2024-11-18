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
    '+' => '-',
    ',' => '',
    ';' => '_',
    '@' => '',
    'Ö' => 'O',
    'Ü' => 'U',
    '[' => '_',
    ']' => '_',
    '^' => '',
    'á' => 'a',
    'č' => 'c',
    'é' => 'e',
    'ě' => 'e',
    'í' => 'i',
    'ö' => 'o',
    'ř' => 'r',
    'š' => 's',
    'ú' => 'u',
    'ü' => 'u',
    'ý' => 'y',
    'ž' => 'z',
    '|' => '',
    '~' => '-',
    '¦' => '',
    'Á' => 'A',
    'É' => 'E',
    'Í' => 'I',
    'Ó' => 'O',
    'Ú' => 'U',
    'Û' => 'U',
    'Ü' => 'U',
    'Ý' => 'Y',
    'à' => 'a',
    'á' => 'a',
    'è' => 'e',
    'é' => 'e',
    'ë' => 'e',
    'í' => 'i',
    'ó' => 'o',
    'ö' => 'o',
    'ø' => 'o',
    'ú' => 'u',
    'û' => 'u',
    'ü' => 'u',
    'ü' => 'u',
    'ý' => 'y',
    'Ć' => 'C',
    'ć' => 'c',
    'Č' => 'C',
    'č' => 'c',
    'Ď' => 'D',
    'ď' => 'd',
    'Ě' => 'E',
    'ě' => 'e',
    'Ĺ' => 'L',
    'ĺ' => 'l',
    'Ľ' => 'l',
    'ľ' => 'l',
    'Ň' => 'N',
    'ň' => 'n',
    'Ŕ' => 'R',
    'ŕ' => 'r',
    'Ř' => 'R',
    'ř' => 'r',
    'Š' => 'S',
    'š' => 's',
    'Ť' => 'T',
    'ť' => 't',
    'Ů' => 'U',
    'ů' => 'u',
    'Ž' => 'Z',
    'ž' => 'z',
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

    echo "Reading folders...\n";
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

        echo "\nFixing folders ($fixes)...\n";
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

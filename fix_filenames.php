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

if (file_exists('.bashrc') || file_exists('.profile')) {
    // stop if running from $HOME directory
    die("EMERGENCY STOP!!!");
}

define("DS", DIRECTORY_SEPARATOR);

$map = [
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
    'ń' => 'n',

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
    'Ń' => 'N',

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

    ' ' => '_',
    '(' => '_',
    ')' => '_',
    '+' => '-',
    ';' => '-',
    '[' => '_',
    ']' => '_',
    '~' => '-',
    '–' => '-',
    '—' => '-',
    '•' => '-',
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
    echo "Reading folders\n";

    foreach ($iterator = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator(
            "./",
            RecursiveDirectoryIterator::SKIP_DOTS
        ), RecursiveIteratorIterator::SELF_FIRST
    ) as $item) {
        $path = $iterator->getSubPath();
        $sub = $iterator->getSubPathName();
        $name = $iterator->getFileName();
        $fix = strtolower(strtr($name, $map));
        $fix = preg_replace('!_+!', '_', $fix);

        $fix = str_replace('-_', '-', $fix);
        $fix = str_replace('.-', '.', $fix);
        $fix = str_replace('-.', '.', $fix);
        $fix = str_replace('._', '.', $fix);
        $fix = str_replace('_-', '-', $fix);
        $fix = str_replace('_.', '.', $fix);
        $fix = str_replace('_-_', '-', $fix);

        $fix = trim($fix, ' _-.');
        $fix = preg_replace('!_+!', '_', $fix);
        $fix = preg_replace('/[^a-z0-9_\-.]/', '', $fix);

        if ($item->isDir()) {
            if ($name != $fix) {
                $dirs[$sub] = substr_count($sub, "/");
                $names1[$sub] = $name;
                $names2[$sub] = $fix;
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
        echo "\nFixing folders: {$fixes}x\n\n";

        $fails = 0;
        foreach ($dirs??=[] as $k => $v) {
            if ($paths[$k] == "") {
                $paths[$k] = ".";
            }
            echo "> $paths[$k]/$names2[$k]\n";
            if (!@rename("$paths[$k]/$names1[$k]", "$paths[$k]/$names2[$k]")) {
                $fails++;
                echo "\n! {$fails}. FAIL: "
                    . "{$paths[$k]}/{$names1[$k]}"
                    . " -> {$paths[$k]}/{$names2[$k]}\n";
            }
        }
    } else {
        $work = false;
    }
} while ($work);

echo "\nFixing files\n";
foreach ($iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator(
        "./",
        RecursiveDirectoryIterator::SKIP_DOTS
    ), RecursiveIteratorIterator::SELF_FIRST
) as $item) {
    $path = $iterator->getSubPath();
    $sub = $iterator->getSubPathName();
    $name = $iterator->getFileName();
    $fix = strtolower(strtr($name, $map));
    $fix = preg_replace('!_+!', '_', $fix);

    $fix = str_replace('-_', '-', $fix);
    $fix = str_replace('.-', '.', $fix);
    $fix = str_replace('-.', '.', $fix);
    $fix = str_replace('._', '.', $fix);
    $fix = str_replace('_-', '-', $fix);
    $fix = str_replace('_.', '.', $fix);
    $fix = str_replace('_-_', '-', $fix);
    $fix = trim($fix, ' _-.');

    $fix = preg_replace('!_+!', '_', $fix);
    $fix = preg_replace('!-+!', '-', $fix);
    $fix = str_replace('..', '.', $fix);
    $fix = preg_replace('/[^a-z0-9_\-.]/', '', $fix);

    // special case
    if ($fix === 'concat') {
        $fix = '.concat';
    }

    if ($item->isDir()) {
        continue;
    } else {
        if (strlen($path) == 0 && $name != $fix) {
            echo " * $fix\n";
            @rename($name, $fix);
        }
        if (strlen($path) && $name != $fix) {
            echo " * $fix\n";
            @rename($path . DS . $name, $path . DS . $fix);
        }
    }
}

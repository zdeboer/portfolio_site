<?php
declare(strict_types=1);

// Minimal phpMyAdmin config for a single-container MariaDB.
// Use PMA_BLOWFISH_SECRET at runtime to avoid warnings.

$cfg['blowfish_secret'] = getenv('PMA_BLOWFISH_SECRET') ?: 'change_this_blowfish_secret_32_chars_min';

$i = 1;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = getenv('DB_HOST') ?: '127.0.0.1';
$cfg['Servers'][$i]['port'] = (int)(getenv('DB_PORT') ?: 3306);
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = true;

// Helps avoid temp-dir warnings in some environments.
$cfg['TempDir'] = '/tmp';

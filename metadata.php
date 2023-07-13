<?php
/**
 * Copyright © FATCHIP GmbH. All rights reserved.
 * See LICENSE file for license details.
 */

/**
 * Metadata version
 */
$sMetadataVersion = '2.1';

$aModule = [
    'id' => 'fcyellowmapac',
    'title' => 'SmartMaps Address Autocomplete & Verification',
    'description' => [
        'de' => 'Integration von SmartMaps Autovervollständigung',
        'en' => 'Integration of SmartMaps Autocomplete',
    ],
    'version' => '1.0.3',
    'author' => 'FATCHIP GmbH im Auftrag der YellowMap AG',
    'email' => 'maps@yellowmap.de',
    'url' => 'https://www.smartmaps.net',
    'thumbnail' => 'img/SmartMaps_poweredbyYM.svg',
    'extend' => [
        \OxidEsales\Eshop\Core\ViewConfig::class => FC\YellowMap\extend\Core\FcViewConfig::class
    ],
    'controllers' => [],
    'settings'   => [
        [
            'group' => 'fcyellowmapac_settings',
            'name' => 'sFcYellowmapAcApiKey',
            'type' => 'str',
            'value' => ''
        ]
    ],
    'events' => [],
];

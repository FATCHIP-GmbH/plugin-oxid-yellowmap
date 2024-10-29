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
    'version' => '1.0.4',
    'author' => 'FATCHIP GmbH im Auftrag der YellowMap AG',
    'email' => 'maps@yellowmap.de',
    'url' => 'https://www.smartmaps.net',
    'thumbnail' => 'SmartMaps_poweredbyYM.svg',
    'extend' => [],
    'controllers' => [],
    'templates' => [],
    'settings'   => [
        [
            'group' => 'fcyellowmapac_settings',
            'name' => 'sFcYellowmapAcApiKey',
            'type' => 'str',
            'value' => ''
        ]
    ],
    'blocks' => [
        [
            'template' => 'form/user_checkout_noregistration.tpl',
            'block'    => 'user_checkout_noregistration_next_step_top',
            'file'     => 'Application/views/blocks/yellowmap.tpl',
        ],
        [
            'template' => 'form/user_checkout_change.tpl',
            'block'    => 'user_checkout_change_next_step_top',
            'file'     => 'Application/views/blocks/yellowmap.tpl',
        ],
        [
            'template' => 'form/user.tpl',
            'block'    => 'user_form',
            'file'     => 'Application/views/blocks/yellowmap.tpl',
        ],
        [
            'template' => 'form/fieldset/user_account.tpl',
            'block'    => 'user_account_newsletter',
            'file'     => 'Application/views/blocks/yellowmap.tpl',
        ],
    ],
    'events' => [],
];

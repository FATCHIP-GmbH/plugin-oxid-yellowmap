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
    'title' => 'FATCHIP Modul YellowMap Address Autocomplete',
    'description' => [
        'de' => 'Integration von SmartMaps Autovervollständigung',
        'en' => 'Integration of SmartMaps Autocomplete',
    ],
    'version' => '1.0.0',
    'author' => 'FATCHIP GmbH',
    'email' => 'support@fatchip.de',
    'url' => '',
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
            'theme' => 'flow',
            'template' => 'form/user_checkout_noregistration.tpl',
            'block'    => 'user_checkout_noregistration_next_step_top',
            'file'     => 'Application/views/flow/blocks/yellowmap_script.tpl',
        ],
        [
            'theme' => 'wave',
            'template' => 'form/user_checkout_noregistration.tpl',
            'block'    => 'user_checkout_noregistration_next_step_top',
            'file'     => 'Application/views/wave/blocks/yellowmap_script.tpl',
        ],

        [
            'theme' => 'flow',
            'template' => 'form/user_checkout_change.tpl',
            'block'    => 'user_checkout_change_next_step_top',
            'file'     => 'Application/views/flow/blocks/yellowmap_script.tpl',
        ],
        [
            'theme' => 'wave',
            'template' => 'form/user_checkout_change.tpl',
            'block'    => 'user_checkout_change_next_step_top',
            'file'     => 'Application/views/wave/blocks/yellowmap_script.tpl',
        ],

        [
            'theme' => 'flow',
            'template' => 'form/user.tpl',
            'block'    => 'user_form',
            'file'     => 'Application/views/flow/blocks/yellowmap_script.tpl',
        ],
        [
            'theme' => 'wave',
            'template' => 'form/user.tpl',
            'block'    => 'user_form',
            'file'     => 'Application/views/wave/blocks/yellowmap_script.tpl',
        ],

        [
            'theme' => 'flow',
            'template' => 'form/fieldset/user_account.tpl',
            'block'    => 'user_account_newsletter',
            'file'     => 'Application/views/flow/blocks/yellowmap_script.tpl',
        ],
        [
            'theme' => 'wave',
            'template' => 'form/fieldset/user_account.tpl',
            'block'    => 'user_account_newsletter',
            'file'     => 'Application/views/wave/blocks/yellowmap_script.tpl',
        ],
    ],
    'events' => [],
];

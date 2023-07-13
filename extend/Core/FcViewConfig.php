<?php
/*
 * @author FATCHIP GmbH
 * @copyright (C) 2023, FATCHIP GmbH
 *
 * This Software is the property of FATCHIP GmbH
 * and is protected by copyright law - it is NOT Freeware.
 *
 * Any unauthorized use of this software without a valid license
 * is a violation of the license agreement and will be
 * prosecuted by civil and criminal law.
 */

namespace FC\YellowMap\extend\Core;

use OxidEsales\Eshop\Core\ViewConfig;
use OxidEsales\EshopCommunity\Internal\Container\ContainerFactory;
use OxidEsales\EshopCommunity\Internal\Framework\Module\Facade\ModuleSettingServiceInterface;

class FcViewConfig extends ViewConfig
{
    public function fcGetYMConfigApiKey()
    {
        $moduleSettingService = ContainerFactory::getInstance()
            ->getContainer()
            ->get(ModuleSettingServiceInterface::class);
        return $moduleSettingService->getString('sFcYellowmapAcApiKey', 'fcyellowmapac');
    }

    public function fcGetYMFullLibraryUrl()
    {
        $sBaseUrl = "https://www.yellowmap.de/api_rst/api/loader?libraries=free-5,autocomplete-5&apiKey=sApiKey&channel=OXIDAV";
        $sBaseUrl = preg_replace("/sApiKey/", $this->fcGetYMConfigApiKey(), $sBaseUrl);

        return $sBaseUrl;
    }
}
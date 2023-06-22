<?php

namespace YellowMaps\Autocomplete\Controller;

use OxidEsales\Eshop\Core\Registry;
use OxidEsales\Eshop\Core\Theme;
use OxidEsales\EshopCommunity\Internal\Container\ContainerFactory;
use OxidEsales\EshopCommunity\Internal\Framework\Module\Facade\ModuleSettingServiceInterface;
use OxidEsales\EshopCommunity\Internal\Framework\Theme\Bridge\AdminThemeBridgeInterface;

class SettingsController extends SettingsController_parent
{
    public function init()
    {
        parent::init();

        $this->addTplParam('apiKey', ContainerFactory::getInstance()
            ->getContainer()
            ->get(ModuleSettingServiceInterface::class)
            ->getString('sFcYellowmapAcApiKey', 'fcyellowmapac')
        );

        $this->addTplParam('aHomeCountry', Registry::getConfig()
            ->getConfigParam('aHomeCountry')
        );

        $this->addTplParam('sActiveThemeId', oxNew(Theme::class)
            ->getActiveThemeId()
        );

        $this->addTplParam('aCountryList', Registry::getConfig()
            ->getActiveView()
            ->getViewConfig()
            ->getCountryList()
        );
    }
}

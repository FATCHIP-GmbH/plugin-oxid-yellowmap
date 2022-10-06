[{if !isset($oConfig)}]
    [{assign var="oConfig" value=$oViewConf->getConfig()}]
[{/if}]
[{assign var="aHomeCountry" value=$oConfig->getConfigParam('aHomeCountry')}]
[{assign var="aCountryList" value=$oViewConf->getCountryList()}]
[{assign var="sActiveThemeId" value=$oViewConf->getActiveTheme()|lower}]

[{$smarty.block.parent}]

<script src="https://www.yellowmap.de/api_rst/api/loader?libraries=free-5,autocomplete-5&apiKey=[{$oConfig->getConfigParam('sFcYellowmapAcApiKey')}]&channel=OXIDAV"></script>
<style>
    @supports (--css: variables) {
        :root {
            --smartmaps-text-color: #555;
            --smartmaps-input-bg-color: #ffffff;
            --smartmaps-border: solid 1px #ccc;
            --smartmaps-border-radius: 4px;
            --smartmaps-boxshadow: none;
            --smartmaps-font-size: 14px;
        }
    }
    [{if $sActiveThemeId == "azure"}]
    .sm-autocomplete {
        border: none;
        float: left;
        margin-right: 5px;
    }
    .sm-autocomplete input[type="text"] {
        border: 1px solid #8c8989;
        border-radius: 4px;
        background: #fff;
        padding: 1px 5px;
        height: 15px;
        line-height: 14px;
        font-size: 11px;
        font-family: Arial, Helvetica, sans-serif;
    }
    .sm-autocomplete > ul {
        margin-top: 25px;
    }
    .sm-autocomplete svg {
        position: absolute;
        top: calc(50% - 12px);
        left: auto;
        right: 10px;
    }
    #awesomplete_list_1 li {
        width: 100%;
    }
    [{elseif $sActiveThemeId == "wave"}]
    .sm-autocomplete {
        display: block;
        border-radius: 4px;
    }
    .sm-autocomplete [type=text] {
        height: calc(1.5em + .75rem + 2px);
        line-height: 1.5;
    }
    [{else}]
    .sm-autocomplete {
        display: block;
        border-radius: 4px;
    }
    [{/if}]
</style>
<script>
    var oFcId2IsoCountryCodes = {
        [{foreach from=$aCountryList item=oCountry key=sCountryId}]
        "[{$sCountryId}]":"[{$oCountry->oxcountry__oxisoalpha2->value}]",
        [{/foreach}]
    };
    var oFcIso2IdCountries = {
        [{foreach from=$aCountryList item=oCountry key=sCountryId}]
        "[{$oCountry->oxcountry__oxisoalpha2->value}]":"[{$sCountryId}]",
        [{/foreach}]
    };
    var aFcAllowedIsoCountries = [
        [{foreach from=$aCountryList item=oCountry key=sCountryId}]
            [{if $sCountryId|in_array:$aHomeCountry}]
            "[{$oCountry->oxcountry__oxisoalpha2->value|lower}]",
            [{/if}]
        [{/foreach}]
    ];

    ym.ready({ autocomplete: 5 }, function (modules) {
        var oFcFieldMappingInv = {
            street: 'invadr[oxuser__oxstreet]',
            houseno: 'invadr[oxuser__oxstreetnr]',
            zip: 'invadr[oxuser__oxzip]',
            city: 'invadr[oxuser__oxcity]',
            state: 'invadr[oxuser__oxstateid]',
            country: 'invadr[oxuser__oxcountryid]'
        };
        var oFcTargetElem = document.getElementsByName(oFcFieldMappingInv.street);
        if (oFcTargetElem.length > 0) {
            fcInitAutocompleteField(modules, 'input[name="' + oFcFieldMappingInv.street + '"]', oFcFieldMappingInv);
        }

        var oFcFieldMappingDel = {
            street: 'deladr[oxaddress__oxstreet]',
            houseno: 'deladr[oxaddress__oxstreetnr]',
            zip: 'deladr[oxaddress__oxzip]',
            city: 'deladr[oxaddress__oxcity]',
            state: 'deladr[oxaddress__oxstateid]',
            country: 'deladr[oxaddress__oxcountryid]'
        }
        oFcTargetElem = document.getElementsByName(oFcFieldMappingDel.street);
        if (oFcTargetElem.length > 0) {
            fcInitAutocompleteField(modules, 'input[name="' + oFcFieldMappingDel.street + '"]', oFcFieldMappingDel);
        }
    });

    function fcInitAutocompleteField(modules, sTargetSelector, oFieldMapping) {
        var oAutoCompleteField = modules.autoComplete(sTargetSelector, {
            isoCountries: fcFetchIsoCountries(oFieldMapping),
            includeFilters: {
            },
            dataType: 'json'
        });
        oAutoCompleteField.on('selected', function (geojson, address, query) {
            fcFillAddress(address, oFieldMapping);
        });
        oAutoCompleteField.on("ready", function () {
            var isFirefox = typeof InstallTrigger !== "undefined";
            if (!isFirefox) {
                this.element.autocomplete = "disabled";
            }
        });
        var oCountrySelector = document.getElementsByName(oFieldMapping.country);
        if (oCountrySelector.length > 0) {
            oCountrySelector = oCountrySelector[0];
            oCountrySelector.onchange = function() {
                oAutoCompleteField.options.isoCountries = fcFetchIsoCountries(oFieldMapping);
            }
        }
    }

    function fcFetchIsoCountries(oFieldMapping) {
        var sSelectedCountryId = '';
        var oCountrySelector = document.getElementsByName(oFieldMapping.country);
        if (oCountrySelector.length > 0) {
            oCountrySelector = oCountrySelector[0];
            sSelectedCountryId = oCountrySelector.value;
        }

        var aIsoCountries = [];
        if (sSelectedCountryId === '') {
            return aFcAllowedIsoCountries;
        }

        if ("undefined" != typeof oFcId2IsoCountryCodes[sSelectedCountryId]) {
            var sSelectedCountryCode = oFcId2IsoCountryCodes[sSelectedCountryId];
            if (sSelectedCountryCode != '') {
                aIsoCountries.push(sSelectedCountryCode.toLowerCase());
            }
        }

        return aIsoCountries;
    }

    function fcFillAddress (oAddress, oFieldMapping) {
        if ("undefined" != typeof oFcIso2IdCountries[oAddress.country]) {
            fcSelectField(oFieldMapping.country, oFcIso2IdCountries[oAddress.country]);     // Country
        }
        fcUpdateField(oFieldMapping.street, oAddress.street);       // Street
        fcUpdateField(oFieldMapping.houseno, oAddress.houseNo);     // Street nr
        fcUpdateField(oFieldMapping.zip, oAddress.zip);             // Zip
        fcUpdateField(oFieldMapping.city, oAddress.city);           // City
        fcSelectField(oFieldMapping.state, oAddress.state);         // State
    }

    function fcUpdateField(sFieldName, sValue) {
        var oAddrElem = document.getElementsByName(sFieldName);
        if (oAddrElem.length > 0) {
            oAddrElem[0].value = sValue ? sValue : "" ;
        }
    }

    function fcSelectField(sFieldName, sSelectedValue) {
        var oAddrElem = document.getElementsByName(sFieldName);
        if (oAddrElem.length > 0) {
            oAddrElem = oAddrElem[0];
            for (var i = 0; i < oAddrElem.options.length; i++) {
                if (oAddrElem.options[i].value == sSelectedValue) {
                    oAddrElem.options[i].select = true;
                    oAddrElem.selectedIndex = i;
                    oAddrElem.dispatchEvent(new Event('change'));
                    break;
                }
            }
        }
    }
</script>
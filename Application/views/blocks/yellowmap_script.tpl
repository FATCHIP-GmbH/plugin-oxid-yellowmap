[{if !isset($oConfig)}]
    [{assign var="oConfig" value=$oViewConf->getConfig()}]
[{/if}]

<script src="https://www.yellowmap.de/api_rst/api/loader?libraries=free-5,autocomplete-5&apiKey=[{$oConfig->getConfigParam('sFcYellowmapAcApiKey')}]"></script>

<script>
    ym.ready({ autocomplete: 5 }, function (modules) {
        var oFcFieldMappingInv = {
            street: 'invadr[oxuser__oxstreet]',
            houseno: 'invadr[oxuser__oxstreetnr]',
            zip: 'invadr[oxuser__oxzip]',
            city: 'invadr[oxuser__oxcity]',
            state: 'invadr[oxuser__oxstateid]',
            country: 'invadr[oxuser__oxcountryid]'
        }
        var oFcAutoCompleteInv = modules.autoComplete('input[name="' + oFcFieldMappingInv.street + '"]', {
            isoCountries: [],
            includeFilters: {
            },
            dataType: 'json'
        });
        oFcAutoCompleteInv.on('selected', function (geojson, address, query) {
            fcFillAddress(address, oFcFieldMappingInv)
        })

        var oFcFieldMappingDel = {
            street: 'deladr[oxaddress__oxstreet]',
            houseno: 'deladr[oxaddress__oxstreetnr]',
            zip: 'deladr[oxaddress__oxzip]',
            city: 'deladr[oxaddress__oxcity]',
            state: 'deladr[oxaddress__oxstateid]',
            country: 'deladr[oxaddress__oxcountryid]'
        }
        var oFcAutoCompleteDel = modules.autoComplete('input[name="' + oFcFieldMappingDel.street + '"]', {
            isoCountries: [],
            includeFilters: {
            },
            dataType: 'json'
        });
        oFcAutoCompleteDel.on('selected', function (geojson, address, query) {
            fcFillAddress(address, oFcFieldMappingDel)
        });
    });

    function fcFillAddress (oAddress, oFieldMapping) {
        var oCountries = {
            [{foreach from=$oViewConf->getCountryList() item=oCountry key=sCountryId}]
            "[{$oCountry->oxcountry__oxisoalpha2->value}]":"[{$sCountryId}]",
            [{/foreach}]
        };

        // Street
        var oAddrElem = document.getElementsByName(oFieldMapping.street);
        if (oAddrElem.length > 0) {
            oAddrElem[0].value = oAddress.street ? oAddress.street : "" ;
        }

        // Street nr
        oAddrElem = document.getElementsByName(oFieldMapping.houseno);
        if (oAddrElem.length > 0) {
            oAddrElem[0].value = oAddress.houseNo ? oAddress.houseNo : "" ;
        }

        // Zip
        oAddrElem = document.getElementsByName(oFieldMapping.zip);
        if (oAddrElem.length > 0) {
            oAddrElem[0].value = oAddress.zip ? oAddress.zip : "" ;
        }

        // City
        oAddrElem = document.getElementsByName(oFieldMapping.city);
        if (oAddrElem.length > 0) {
            oAddrElem[0].value = oAddress.city ? oAddress.city : "" ;
        }

        // Country
        if ("undefined" != typeof oCountries[oAddress.country]) {
            oAddrElem = document.getElementsByName(oFieldMapping.country);
            if (oAddrElem.length > 0) {
                oAddrElem = oAddrElem[0];
                for (var i = 0; i < oAddrElem.options.length; i++) {
                    if (oAddrElem.options[i].value == oCountries[oAddress.country]) {
                        oAddrElem.options[i].select = true;
                        oAddrElem.selectedIndex = i;
                        oAddrElem.dispatchEvent(new Event('change'));
                        break;
                    }
                }
            }
        }

        // State
        oAddrElem = document.getElementsByName(oFieldMapping.state);
        if (oAddrElem.length > 0) {
            oAddrElem = oAddrElem[0];
            for (var i = 0; i < oAddrElem.options.length; i++) {
                if (oAddrElem.options[i].value == oAddress.state) {
                    oAddrElem.options[i].select = true;
                    oAddrElem.selectedIndex = i;
                    oAddrElem.dispatchEvent(new Event('change'));
                    break;
                }
            }
        }
    }
</script>

[{$smarty.block.parent}]
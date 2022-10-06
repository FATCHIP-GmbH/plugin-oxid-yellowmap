[{if !isset($oConfig)}]
    [{assign var="oConfig" value=$oViewConf->getConfig()}]
[{/if}]
[{assign var="aCountryList" value=$oViewConf->getCountryList()}]


<div>
    <h1>VALIDATION</h1>
    <div id="fc_yellowmap_validation_inv" class="alert alert-info" style="display: none">
        <p style="display: inline-block">[{ oxmultilang ident="INVOICE_ADDRESS_SUGGESTION" }]<span id="fc_yellowmap_validation_hint_inv"></span></p>
        <p class="button" style="display: inline-block"><input type="button" onclick="fcAcceptSuggestion('inv')" value="[{oxmultilang ident='YES'}]" /></p>
        <p class="button" style="display: inline-block"><input type="button" onclick="fcDeclineSuggestion('inv')" value="[{oxmultilang ident='NO'}]" /></p>
    </div>
    <div id="fc_yellowmap_validation_ok_inv" class="alert alert-info" style="display: none">
        <p>[{ oxmultilang ident="INVOICE_ADDRESS_CONFIRMED" }]</p>
    </div>
    <div id="fc_yellowmap_validation_del" class="alert alert-info" style="display: none">
        <p style="display: inline-block">[{ oxmultilang ident="DELIVERY_ADDRESS_SUGGESTION" }]<span id="fc_yellowmap_validation_hint_del"></span></p>
        <p class="button" style="display: inline-block"><input type="button" onclick="fcAcceptSuggestion('del')" value="[{oxmultilang ident='YES'}]" /></p>
        <p class="button" style="display: inline-block"><input type="button" onclick="fcDeclineSuggestion('del')" value="[{oxmultilang ident='NO'}]" /></p>
    </div>
    <div id="fc_yellowmap_validation_ok_del" class="alert alert-info" style="display: none">
        <p>[{ oxmultilang ident="DELIVERY_ADDRESS_CONFIRMED" }]</p>
    </div>
</div>
<script type="text/javascript">
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
    var oFcFieldMappingInv = {
        street: 'invadr[oxuser__oxstreet]',
        houseNo: 'invadr[oxuser__oxstreetnr]',
        zip: 'invadr[oxuser__oxzip]',
        city: 'invadr[oxuser__oxcity]',
        state: 'invadr[oxuser__oxstateid]',
        country: 'invadr[oxuser__oxcountryid]'
    };
    var oFcFieldMappingDel = {
        street: 'deladr[oxaddress__oxstreet]',
        houseno: 'deladr[oxaddress__oxstreetnr]',
        zip: 'deladr[oxaddress__oxzip]',
        city: 'deladr[oxaddress__oxcity]',
        state: 'deladr[oxaddress__oxstateid]',
        country: 'deladr[oxaddress__oxcountryid]'
    }
    var sFcValidatedInvAddress = '';
    var oFcSuggestedInvAddress = '';
    var sFcValidatedDelAddress = '';
    var oFcSuggestedDelAddress = '';
    var blFcAddressCheckStep = 'inv';

    ym.ready(function(modules) {
        var oSubmitButton = fcDetectSubmitButton();

        oSubmitButton.onclick = function (evt) {
            evt.preventDefault();
            var blAddressesValidation = true;

            var oSelectedInvAddress = fcGetSelectedAddress(oFcFieldMappingInv);
            if (fcGetAddressString(oSelectedInvAddress) !== sFcValidatedInvAddress) {
                blAddressesValidation = false;
                fcCheckAddress(modules, oSelectedInvAddress, blFcAddressCheckStep);
            }
            blFcAddressCheckStep = 'del';
            var oSelectedDelAddress = fcGetSelectedAddress(oFcFieldMappingDel)
            if (fcGetAddressString(oSelectedDelAddress) !== sFcValidatedDelAddress) {
                blAddressesValidation = false;
                fcCheckAddress(modules, oSelectedDelAddress, blFcAddressCheckStep);
            }
        };
    });

    function fcDetectSubmitButton() {
        var oSubmit = document.getElementById('userNextStepBottom');
        if (oSubmit) {
            return oSubmit;
        }

        oSubmit = document.getElementById('accUserSaveTop');
        if (oSubmit) {
            return oSubmit;
        }

        return false;
    }

    function fcShowSuggestionBox(sSuggestedAddressString, sSection) {
        document.getElementById('fc_yellowmap_validation_hint_' + sSection).innerText = sSuggestedAddressString;
        document.getElementById('fc_yellowmap_validation_ok_' + sSection).style.display = 'none';
        document.getElementById('fc_yellowmap_validation_' + sSection).style.display = 'block';
    }

    function fcAcceptSuggestion(sSection) {
        document.getElementById('fc_yellowmap_validation_' + sSection).style.display = 'none';

        var oSelectedAddress = sSection === 'del' ? oFcSuggestedDelAddress : oFcSuggestedInvAddress;
        var oFieldMapping = sSection === 'del' ? oFcFieldMappingDel : oFcFieldMappingInv;
        fcFillAddress(oSelectedAddress, oFieldMapping);
    }

    function fcDeclineSuggestion(sSection) {
        fcShowValidatedBox(sSection);
        if (sSection === 'del') {
            sFcValidatedDelAddress = fcGetAddressString(fcGetSelectedAddress(oFcFieldMappingDel));
        } else {
            sFcValidatedInvAddress = fcGetAddressString(fcGetSelectedAddress(oFcFieldMappingInv));
        }
    }

    function fcShowValidatedBox(sSection) {
        document.getElementById('fc_yellowmap_validation_ok_' + sSection).style.display = 'block';
        document.getElementById('fc_yellowmap_validation_' + sSection).style.display = 'none';
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

    function fcCheckAddress (modules, oSelectedAddress, sSection) {
        ym.services.geoCoder.on('success', function(req, res) {
            if (res.body && res.body.features && res.body.features.length) {
                var oFeature = res.body.features[0];

                var sSelectedAddressString = fcGetAddressString(oSelectedAddress);

                var oSuggestedAddress = {
                    country: oFeature.properties.isoCountry,
                    state: oFeature.properties.district,
                    zip: oFeature.properties.zip,
                    city: oFeature.properties.city,
                    street: oFeature.properties.street,
                    houseNo: oFeature.properties.houseNo
                };
                var sSuggestedAddressString = fcGetAddressString(oSuggestedAddress);

                if (sSelectedAddressString.toLowerCase() !== sSuggestedAddressString.toLowerCase()) {
                    fcShowSuggestionBox(sSuggestedAddressString, sSection);
                    if (sSection === 'del') {
                        oFcSuggestedDelAddress = oSuggestedAddress;
                    } else {
                        oFcSuggestedInvAddress = oSuggestedAddress;
                    }
                } else {
                    if (sSection === 'del') {
                        sFcValidatedDelAddress = sSelectedAddressString;
                    } else {
                        sFcValidatedInvAddress = sSelectedAddressString;
                    }
                }
            } else {
                console.log('Address could not be validated.')
            }
        });
        ym.services.geoCoder.on('error', function(req, res, errorType) {
            console.log('ERROR');
        });

        modules.geocode(oSelectedAddress);
    }

    function fcGetSelectedAddress(oFieldMapping) {
        var oSelectedAddress = {
            "country": "",
            "district": "",
            "zip": "",
            "city": "",
            "cityAddOn": "",
            "cityPart": "",
            "street": "",
            "houseNo": "",
            "singleSlot": ""
        };
        Object.keys(oFieldMapping).forEach(function(index) {
            var oAddrElem = document.getElementsByName(oFieldMapping[index]);
            if (oAddrElem.length > 0) {
                oAddrElem = oAddrElem[0];

                if (oSelectedAddress.hasOwnProperty(index)) {
                    if (index === 'country' && "undefined" != typeof oFcId2IsoCountryCodes[oAddrElem.value]) {
                        oSelectedAddress['country'] = oFcId2IsoCountryCodes[oAddrElem.value];
                    } else {
                        oSelectedAddress[index] = oAddrElem.value;
                    }
                }
            }
        });

        return oSelectedAddress;
    }

    function fcGetAddressString (oAddress) {
        var sAddressString =
            (oAddress.country != null ? oAddress.country + "," : '') +
            (oAddress.zip != null ? oAddress.zip + "," : '') +
            (oAddress.city != null ? oAddress.city + "," : '') +
            (oAddress.street != null ? oAddress.street + "," : '') +
            (oAddress.houseNo != null ? oAddress.houseNo + "," : '');
        while (sAddressString.charAt(sAddressString.length - 1) === ',') {
            sAddressString = sAddressString.slice(0, -1);
        }

        return sAddressString;
    }
</script>
[{$smarty.block.parent}]
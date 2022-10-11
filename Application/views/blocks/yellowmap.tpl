[{if !isset($oConfig)}]
    [{assign var="oConfig" value=$oViewConf->getConfig()}]
[{/if}]
[{assign var="aHomeCountry" value=$oConfig->getConfigParam('aHomeCountry')}]
[{assign var="aCountryList" value=$oViewConf->getCountryList()}]
[{assign var="sActiveThemeId" value=$oViewConf->getActiveTheme()|lower}]

[{$smarty.block.parent}]

[{oxscript include=$oViewConf->getModuleUrl('fcyellowmapac', 'out/src/js/fc_fcyellowmap.js')}]

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
    var iso2Id = {
    };
    var id2Iso = {
    };
    var allowedIso = [];

    [{foreach from=$aCountryList item=oCountry key=sCountryId}]
    id2Iso["[{$sCountryId}]"] = "[{$oCountry->oxcountry__oxisoalpha2->value}]";
    iso2Id["[{$oCountry->oxcountry__oxisoalpha2->value}]"] = "[{$sCountryId}]";
    [{if $sCountryId|in_array:$aHomeCountry}]
    allowedIso.push("[{$oCountry->oxcountry__oxisoalpha2->value|lower}]");
    [{/if}]
    [{/foreach}]

    document.addEventListener("DOMContentLoaded", function(event) {
        initCountriesLists(id2Iso, iso2Id, allowedIso);

        ym.ready({ autocomplete: 5 }, function (modules) {
            var oFcTargetElem = document.getElementsByName(oFcFieldMappingInv.street);
            if (oFcTargetElem.length > 0) {
                fcInitAutocompleteField(modules, 'input[name="' + oFcFieldMappingInv.street + '"]', oFcFieldMappingInv);
            }
            oFcTargetElem = document.getElementsByName(oFcFieldMappingDel.street);
            if (oFcTargetElem.length > 0) {
                fcInitAutocompleteField(modules, 'input[name="' + oFcFieldMappingDel.street + '"]', oFcFieldMappingDel);
            }
        });
    });

    function fcInitAutocompleteField(modules, sTargetSelector, oFieldMapping) {
        var oAutoCompleteField = modules.autoComplete(sTargetSelector, {
            isoCountries: fcFetchIsoCountries(oFieldMapping),
            includeFilters: {
            },
            dataType: 'json',
            onSelected: function (geojson, address, query) {
                fcFillAddress(address, oFieldMapping);
            },
            onReady: function () {
                var isFirefox = typeof InstallTrigger !== "undefined";
                if (!isFirefox) {
                    this.element.autocomplete = "disabled";
                }
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
</script>

<script type="text/javascript">
    var aFcAddressesList = {
        'inv': {
            'validated': '',
            'suggested': null,
            'selected' : ''
        },
        'del': {
            'validated': '',
            'suggested': null,
            'selected' : ''
        }
    };
    document.addEventListener("DOMContentLoaded", function(event) {
        var blFcMessageBoxesCreated = fcAppendMessageBoxes();

        if (blFcMessageBoxesCreated) {
            var blFcAddressCheckStep = '';

            ym.ready(function(modules) {
                var oSubmitButton = fcDetectSubmitButton();

                oSubmitButton.onclick = function (evt) {
                    fcHideAllBoxes();

                    var oSelectedInvAddress = fcGetSelectedAddress(oFcFieldMappingInv);
                    aFcAddressesList.inv.selected = fcGetAddressString(oSelectedInvAddress);

                    var oSelectedDelAddress = fcGetSelectedAddress(oFcFieldMappingDel)
                    aFcAddressesList.del.selected = fcGetAddressString(oSelectedDelAddress);

                    if ((fcIsCheckNeeded('inv') && aFcAddressesList.inv.selected !== aFcAddressesList.inv.validated)
                        || (fcIsCheckNeeded('del') && aFcAddressesList.del.selected !== aFcAddressesList.del.validated))
                    {
                        evt.preventDefault();

                        blFcAddressCheckStep = 'inv';
                        if (fcIsCheckNeeded(blFcAddressCheckStep) && aFcAddressesList.inv.selected !== aFcAddressesList.inv.validated) {
                            modules.geocode(oSelectedInvAddress);
                        } else {
                            blFcAddressCheckStep = 'del';
                            if (fcIsCheckNeeded(blFcAddressCheckStep) && aFcAddressesList.del.selected !== aFcAddressesList.del.validated)
                            {
                                modules.geocode(oSelectedDelAddress);
                            }
                        }
                    }
                };

                ym.services.geoCoder.on('success', function(req, res) {
                    if (res.body && res.body.features && res.body.features.length) {
                        var oFeature = res.body.features[0];

                        var sSelectedAddressString = aFcAddressesList[blFcAddressCheckStep].selected

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
                            fcShowSuggestionBox(sSuggestedAddressString, blFcAddressCheckStep);
                            aFcAddressesList[blFcAddressCheckStep].suggested = oSuggestedAddress;
                        } else {
                            aFcAddressesList[blFcAddressCheckStep].validated = sSelectedAddressString;
                        }

                        if (blFcAddressCheckStep == 'inv') {
                            blFcAddressCheckStep = 'del';
                            var oSelectedDelAddress = fcGetSelectedAddress(oFcFieldMappingDel)
                            aFcAddressesList.del.selected = fcGetAddressString(oSelectedDelAddress);
                            if (fcIsCheckNeeded(blFcAddressCheckStep) && aFcAddressesList.del.selected !== aFcAddressesList.del.validated) {
                                modules.geocode(oSelectedDelAddress);
                            }
                        }
                    } else {
                        console.log('Address could not be validated.')
                    }
                });
                ym.services.geoCoder.on('error', function(req, res, errorType) {
                    console.log('ERROR:' + errorType);
                });
            });
        }
    });

    function fcAcceptSuggestion(sSection) {
        document.getElementById('fc_yellowmap_validation_' + sSection).style.display = 'none';

        var oFieldMapping = sSection === 'del' ? oFcFieldMappingDel : oFcFieldMappingInv;
        aFcAddressesList[sSection].validated = fcGetAddressString(aFcAddressesList[sSection].suggested);

        fcFillAddress(aFcAddressesList[sSection].suggested, oFieldMapping);
    }

    function fcDeclineSuggestion(sSection) {
        fcShowValidatedBox(sSection);

        var oFieldMapping = sSection === 'del' ? oFcFieldMappingDel : oFcFieldMappingInv;
        aFcAddressesList[sSection].validated = fcGetAddressString(fcGetSelectedAddress(oFieldMapping));
    }

    function fcAppendMessageBoxes () {
        var oFcTargetElement = document.getElementsByClassName('checkoutCollumns');
        var sFcContext = null;
        if (oFcTargetElement.length > 0) {
            oFcTargetElement = oFcTargetElement[oFcTargetElement.length - 1];
            sFcContext = 'checkout';
        } else{
            oFcTargetElement = document.getElementsByClassName('addressCollumns');
            if (oFcTargetElement.length > 0) {
                oFcTargetElement = oFcTargetElement[oFcTargetElement.length - 1];
                sFcContext = 'user';
            } else {
                oFcTargetElement = document.getElementById('accUserSaveTop');
                if (oFcTargetElement) {
                    sFcContext = 'register';
                }
            }
        }

        if (!sFcContext) {
            console.log('Error : impossible to initialize message boxes.');
            return false;
        }

        var oFcBoxContainer = fcGenerateMessageBoxElements();

        switch (sFcContext) {
            case 'checkout':
                oFcTargetElement.after(oFcBoxContainer);
                break;
            case 'user':
                oFcTargetElement.after(oFcBoxContainer);
                break;
            case 'register':
                oFcTargetElement.parentElement.parentElement.before(oFcBoxContainer);
                break;
        }

        return true;
    }

    function fcGenerateMessageBoxElements() {
        var oFcBoxContainer = document.createElement("div");
        var oFcInvBoxContainer = fcHtmlToElement(
            '<div id="fc_yellowmap_validation_inv" class="alert alert-info" style="display: none">' +
            '<p style="display: inline-block">[{ oxmultilang ident="INVOICE_ADDRESS_SUGGESTION" }]<span id="fc_yellowmap_validation_hint_inv"></span></p>' +
            '<p class="button" style="display: inline-block"><input type="button" onclick="fcAcceptSuggestion(\'inv\')" value="[{oxmultilang ident='YES'}]" /></p>' +
            '<p class="button" style="display: inline-block"><input type="button" onclick="fcDeclineSuggestion(\'inv\')" value="[{oxmultilang ident='NO'}]" /></p>' +
            '</div>'
        );

        var oFcInvOkBoxContainer = fcHtmlToElement(
            '<div id="fc_yellowmap_validation_ok_inv" class="alert alert-info" style="display: none">' +
            '<p>[{ oxmultilang ident="INVOICE_ADDRESS_CONFIRMED" }]</p>' +
            '</div>'
        );

        var oFcDelBoxContainer = fcHtmlToElement(
            '<div id="fc_yellowmap_validation_del" class="alert alert-info" style="display: none">' +
            '<p style="display: inline-block">[{ oxmultilang ident="DELIVERY_ADDRESS_SUGGESTION" }]<span id="fc_yellowmap_validation_hint_del"></span></p>' +
            '<p class="button" style="display: inline-block"><input type="button" onclick="fcAcceptSuggestion(\'del\')" value="[{oxmultilang ident='YES'}]" /></p>' +
            '<p class="button" style="display: inline-block"><input type="button" onclick="fcDeclineSuggestion(\'del\')" value="[{oxmultilang ident='NO'}]" /></p>' +
            '</div>'
        );

        var oFcDelOkBoxContainer = fcHtmlToElement(
            '<div id="fc_yellowmap_validation_ok_del" class="alert alert-info" style="display: none">' +
            '<p>[{ oxmultilang ident="DELIVERY_ADDRESS_CONFIRMED" }]</p>' +
            '</div>'
        );

        oFcBoxContainer.append(oFcInvBoxContainer);
        oFcBoxContainer.append(oFcInvOkBoxContainer);
        oFcBoxContainer.append(oFcDelBoxContainer);
        oFcBoxContainer.append(oFcDelOkBoxContainer);

        return oFcBoxContainer;
    }
</script>
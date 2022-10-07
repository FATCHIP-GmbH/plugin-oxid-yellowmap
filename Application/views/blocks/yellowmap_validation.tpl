[{if !isset($oConfig)}]
    [{assign var="oConfig" value=$oViewConf->getConfig()}]
[{/if}]
[{assign var="aCountryList" value=$oViewConf->getCountryList()}]

[{oxscript include=$oViewConf->getModuleUrl('fcyellowmapac', 'out/src/js/fc_yellowmap.js')}]

<div>
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
        var blFcAddressCheckStep = '';

        ym.ready(function(modules) {
            var oSubmitButton = fcDetectSubmitButton();

            oSubmitButton.onclick = function (evt) {
                var oSelectedInvAddress = fcGetSelectedAddress(oFcFieldMappingInv);
                aFcAddressesList.inv.selected = fcGetAddressString(oSelectedInvAddress);

                var oSelectedDelAddress = fcGetSelectedAddress(oFcFieldMappingDel)
                aFcAddressesList.del.selected = fcGetAddressString(oSelectedDelAddress);

                if (aFcAddressesList.inv.selected !== aFcAddressesList.inv.validated
                    || aFcAddressesList.del.selected !== aFcAddressesList.del.validated) {
                    evt.preventDefault();

                    blFcAddressCheckStep = 'inv';
                    if (aFcAddressesList.inv.selected !== aFcAddressesList.inv.validated) {
                        modules.geocode(oSelectedInvAddress);
                    } else {
                        blFcAddressCheckStep = 'del';
                        if (aFcAddressesList.del.selected !== aFcAddressesList.del.validated) {
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
                        if (aFcAddressesList.del.selected !== aFcAddressesList.del.validated) {
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
</script>
[{$smarty.block.parent}]
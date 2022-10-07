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
</script>
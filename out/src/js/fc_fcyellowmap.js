// document.addEventListener("DOMContentLoaded", function(event) {
// });
var oFcId2IsoCountryCodes = {};
var oFcIso2IdCountries = {};
var aFcAllowedIsoCountries = [];
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
    houseNo: 'deladr[oxaddress__oxstreetnr]',
    zip: 'deladr[oxaddress__oxzip]',
    city: 'deladr[oxaddress__oxcity]',
    state: 'deladr[oxaddress__oxstateid]',
    country: 'deladr[oxaddress__oxcountryid]'
}

function initCountriesLists(oFcId2Iso, oFcIso2Id, aFcAllowedIso) {
    oFcId2IsoCountryCodes = oFcId2Iso;
    oFcIso2IdCountries = oFcIso2Id;
    aFcAllowedIsoCountries = aFcAllowedIso;
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

function fcShowSuggestionBox(sSuggestedAddressString, sSection) {
    document.getElementById('fc_yellowmap_validation_hint_' + sSection).innerText = sSuggestedAddressString;
    document.getElementById('fc_yellowmap_validation_ok_' + sSection).style.display = 'none';
    document.getElementById('fc_yellowmap_validation_' + sSection).style.display = 'block';
}

function fcShowValidatedBox(sSection) {
    document.getElementById('fc_yellowmap_validation_ok_' + sSection).style.display = 'block';
    document.getElementById('fc_yellowmap_validation_' + sSection).style.display = 'none';
}

function fcHideAllBoxes () {
    document.getElementById('fc_yellowmap_validation_inv').style.display = 'none';
    document.getElementById('fc_yellowmap_validation_ok_inv').style.display = 'none';
    document.getElementById('fc_yellowmap_validation_del').style.display = 'none';
    document.getElementById('fc_yellowmap_validation_ok_del').style.display = 'none';

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

function fcFillAddress (oAddress, oFieldMapping) {
    if ("undefined" != typeof oFcIso2IdCountries[oAddress.country]) {
        fcSelectField(oFieldMapping.country, oFcIso2IdCountries[oAddress.country]);     // Country
    }
    fcUpdateField(oFieldMapping.street, oAddress.street);       // Street
    fcUpdateField(oFieldMapping.houseNo, oAddress.houseNo);     // Street nr
    fcUpdateField(oFieldMapping.zip, oAddress.zip);             // Zip
    fcUpdateField(oFieldMapping.city, oAddress.city);           // City
    fcSelectField(oFieldMapping.state, oAddress.state);         // State

    if (oAddress.houseNo == '' || oAddress.houseNo == null) {
        var oAddrElem = document.getElementsByName(oFieldMapping.houseNo);
        if (oAddrElem.length > 0) {
            oAddrElem[0].focus();
        }
    }
}

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

function fcHtmlToElement(html) {
    var template = document.createElement('template');
    html = html.trim();
    template.innerHTML = html;
    return template.content.firstChild;
}

function fcIsCheckNeeded (sSection) {
    if (sSection === 'del') {
        var blShowShipAddrBox = document.getElementById('showShipAddress');
        if (blShowShipAddrBox && blShowShipAddrBox.checked === true) {
            return false;
        }

        var oDelAddressForm = document.getElementById('shippingAddressForm');
        if (oDelAddressForm && oDelAddressForm.style.display == 'none') {
            return false;
        }
    }

    if (sSection === 'inv') {
        var oInvAddressForm = document.getElementById('addressForm');
        if (oInvAddressForm && oInvAddressForm.style.display == 'none') {
            return false;
        }
    }

    return true;
}
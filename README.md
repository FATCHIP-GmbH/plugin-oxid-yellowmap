# YellowMaps Address Autocompletion Module for OXID eShop
An OXID eShop module to suggest address information in the registration formular.

## Disclaimer
This module is only intended to use during the OXID Company Offsite workshop for learning purpose. It was updated to OXID eShop 7 by OXID Support, but not sufficiently tested. Features were removed. Do **NOT** use this version by OXID Support!

The original module is found at [FATCHIP GmbH](https://wiki.fatchip.de/public/faqyellowmap).

## Installation
Install with Composer:

```
composer config repositories.oxsfcymaa vcs https://github.com/oxid-support/yellow-maps-autocompletion
composer require oxid-support/yellow-maps-autocompletion
```

Then activate the module via command or in administration area.

## Configuration
You must register on [SmartMaps](https://www.smartmaps.net/preise/#reg-form) with an email a your shop's domain. Afterwards you get an email with your API key. This key must be set in the module settings.

## Usage
When a new user wants to register in your shop, the registration formular shows a search field instead of the usual street input. When the user starts to type their address, YellowMaps provides address suggestions. If a suggestion is selected, the fields street (now search), No., Postal code, City and Country are filled automatically.

The module only works on the standard registration page - not during checkout!

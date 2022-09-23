# Plugin-oxid-yellowmap
An Oxid eShop plugin to suggest address in forms

## Installation via composer

- In the composer.json file add a new repository

    - manual
  ```
   "repositories": [
      {
        "type": "vcs",
        "url": "https://github.com/FATCHIP-GmbH/plugin-oxid-yellowmap"
      }
    ]
  ```
    -  command line
  ```
  composer config repositories.fatchip-gmbh/plugin-oxid-yellowmap vcs https://github.com/FATCHIP-GmbH/plugin-oxid-yellowmap
  ```

- execute the following command in the shop base folder (where the composer.json file is located)
```
composer require fatchip-gmbh/plugin-oxid-yellowmap --update-no-dev
```
- activate the module after the composer install is finished
```
vendor/bin/oe-console oe:module:activate fcyellowmapac
```

## Manual Installation
- Copy the content into source/modules of the shop installation

- Connect to the webserver with a console, navigate to the shop base folder
- install oxid module configuration
```
vendor/bin/oe-console oe:module:install-configuration source/modules/fc/fcyellowmapac
```

- apply oxid module configuration
```
vendor/bin/oe-console oe:module:apply-configuration
```

- activate oxid module
```
vendor/bin/oe-console oe:module:activate fcyellowmapac
```

## Configuration

### Module Configuration
Through the module settings you can setup the Smartmaps API Key, mandatory to use the functionality. 

See https://www.smartmaps.net/

## Author
FATCHIP GmbH | https://www.fatchip.de | support@fatchip.de

## License
see LICENSE file
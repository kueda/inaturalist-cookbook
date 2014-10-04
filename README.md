# inaturalist-cookbook

## Description

Chef recipes needed to build development and production machines for [iNaturalist](http://www.inaturalist.org/)

## Recipes

### default

Installs some basic system packages such as Vim, git, curl

### database

Installs PostgreSQL and postgis, and bootstraps a postgis template. This recipe can also create and import a copy of the database when used with Vagrant. If there is a PostgreSQL dump file named `inaturalist_production.csql` in root directory of the [iNaturalist Vagrant](https://github.com/pleary/inaturalist-vagrant) codebase, it will be imported to a new database named `inaturalist_production`.

### development, _development_config

Installs RVM and the version of Ruby that the [iNaturalist Ruby on Rails codebase](https://github.com/inaturalist/inaturalist) currently requires, as well as all other dependencies. It then checks out the master branch of the [inaturalist](https://github.com/inaturalist/inaturalist) repo, updates Rails configuration files, and runs a `bundle install`.

This recipe is primarily used with [iNaturalist Vagrant](https://github.com/pleary/inaturalist-vagrant) configuration to create development machines with VirtualBox.

### windshaft

Installs nodejs, mapnik, and all other dependencies needed to run the [iNaturalist Windshaft](https://github.com/inaturalist/Windshaft-inaturalist) application. Windshaft will be installed as a service and can be started with `sudo start windshaft`. This also installs Varnish and configures it to cache all requests both tiles and metadata.

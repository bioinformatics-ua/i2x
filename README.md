# i2x

**[i2x](https://bioinformatics.ua.pt/i2x/): integrate everything**

**i2x** is a barebones framework for deploying custom automated, real-time, data integration platform.

## Setup

**Note**: The full **i2x** experience requires two additional components. [Redis](http://redis.io) and [Sentry](http://getsentry.com). Redis is used to improve the content change detection cache performance, and Sentry is used to capture miscellaneous events during execution.  Both of these tools can be freely downloaded and deployed.

1. Clone or download **i2x** code from GitHub

2. Configure your database, services, mail, Redis and Sentry settings

        config/database.yml
        config/application.yml # copy from config/application.sample.yml

3. Run Rails *bundler* (watch out for *gem* install errors)

        bundle install

4. Create and load database

        rake db:create
        rake db:migrate

5. Run on *rails*

        rails s

6. Initiate the tasks (on a distinct shell, check *delayed_job* documentation)

    rake jobs:work



## Changelog

2014-01-10

* Fixed job queue integration

2014-01-08

* Moved all configuration properties (internal, mail, services) to a single configuration file _config/application.yml_ importing everything to environment variables. Setup using Figaro gem.

2014-01-07

* Added support for DropBox and registration/signin from common social services (Facebook, Dropbox, Github, Google and LinkedIn)

2013-12-20

* v0.1 release

2013-11-11

* accomplished full integration

2013-09-20

* main release for docs to https://bioinformatics.ua.pt/i2x

2013-07-30

* release docs v0.1 to http://pedrolopes.net/i2x/

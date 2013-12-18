# i2x

**[i2x](http://bioinformatics.ua.pt/i2x/): integrate everything**

**i2x** is a barebones framework for deploying custom automated, real-time, data integration platform.

## Setup

**Note**: The full **i2x** experience requires two additional components. [Redis](http://redis.io) and [Sentry](http://getsentry.com). Redis is used to improve the content change detection cache performance, and Sentry is used to capture miscellaneous events during execution.  Both of these tools can be freely downloaded and deployed.

1. Clone or download **i2x** code from GitHub

2. Configure your database, mail and Redis/Sentry settings

    config/database.yml
    config/settings.yml

3. Run Rails *bundler* (watch out for *gem* install errors)

    bundle install

4. Create and load database

    rake db:migrate

5. Run on *rails*

    rails s



## Changelog

2013-12-20

* v0.1 release

2013-11-11

* accomplished full integration

2013-09-20

* main release for docs to http://bioinformatics.ua.pt/i2x

2013-07-30

* release docs v0.1 to http://pedrolopes.net/i2x/

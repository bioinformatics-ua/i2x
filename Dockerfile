FROM cloudgear/build-deps:14.04

MAINTAINER Luis Bastiao <luis.kop@gmail.com>
 
# Use a version available on the Brightbox repo (https://www.brightbox.com/docs/ruby/ubuntu/)
ENV RUBY_VERSION 2.1

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C3173AA6 && \
    echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main > /etc/apt/sources.list.d/brightbox-ruby-ng-trusty.list && \
    apt-get update -q && apt-get install -yq --no-install-recommends \
        ruby$RUBY_VERSION \
        ruby$RUBY_VERSION-dev && \

    # clean up
    rm -rf /var/lib/apt/lists/* && \
    truncate -s 0 /var/log/*log && \

    # Setup Rubygems
    echo 'gem: --no-document' > /etc/gemrc && \
    gem install bundler && gem update --system


RUN apt-get update 
RUN apt-get install -y libarchive-dev libv8-dev nodejs r-base

ADD . /i2x
RUN cd /i2x
RUN cp /i2x/config/application.docker.yml /i2x/config/application.yml
RUN cp /i2x/config/database.docker.yml /i2x/config/database.yml
RUN cd /i2x && bundle install
EXPOSE 3000

ADD ./start.sh /i2x/start.sh
RUN chmod +x /i2x/start.sh
CMD cd /i2x && ./start.sh

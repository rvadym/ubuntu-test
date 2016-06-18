FROM ubuntu:14.04
MAINTAINER Vadym

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Our user in the container
USER root
WORKDIR /root

# Need to generate our locale.
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# ----------------------------------------------------------------------
#
#                           INSTALL SOFTWARE
#
# ----------------------------------------------------------------------

RUN \
    \
    # Enable PHP 5.6 repo
    echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \

    # Install required software
    apt-get update && apt-get install --no-install-recommends -y \

		curl ca-certificates \

		sqlite3 \
		#git \
		#htop man unzip vim \
		wget  \

		php5-cli \
		php5-dev \
		#php5-xdebug \
		php5-apcu \
		php5-json \
		#php5-memcached \
		#php5-memcache \
		#php5-mysql \
		#php5-pgsql \
		#php5-mongo \
		php5-sqlite \
		#php5-sybase \
		#php5-interbase \
		#php5-odbc \
		#php5-gearman \
		php5-mcrypt  \
		php5-ldap \
		php5-gmp  \
		php5-intl \
		php5-geoip \
		#php5-imagick \
		#php5-gd \
		php5-imap \
		php5-curl \
		php5-oauth \
		php5-redis \
		php5-ps \
		php5-enchant \
		php5-xsl \
		php5-xmlrpc \
		php5-tidy \
		php5-recode \
		php5-readline \
		php5-pspell \
		php-pear && \

    # Check PHP version
    php --version && \
    php -m && \

    # Remove preinstaller java libraries
    apt-get remove icedtea* -y openjdk-6* -y && \

    # Intall elasticsearch, nodejs and java
    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - && \
    echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-1.7.list && \
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    apt-get update -y && apt-get install -y \
        openjdk-7-jre \
        openjdk-7-jdk \
        elasticsearch \
        nodejs && \

    /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head && \

    # Install elastick dump
    npm install elasticdump -g && \


    # Tidy up
    apt-get -y autoremove && apt-get clean && apt-get autoclean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

    # Install composer
    curl https://getcomposer.org/installer | php -- && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# INSTALL SOFTWARE ----------------------------------------------------------------------



# Allow mounting files
VOLUME ["/root"]
VOLUME ["/app"]


# Expose elastisearch ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
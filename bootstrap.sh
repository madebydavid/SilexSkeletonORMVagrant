#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y lamp-server^
apt-get install -y php5-curl
apt-get install -y git
apt-get install -y curl
apt-get install -y vim
apt-get install -y php5-gd
apt-get install -y php5-intl
apt-get install -y php5-imagick

rm -rf /var/www
ln -fs /vagrant/site /var/www

cp /vagrant/conf/local.mysite.com /etc/apache2/sites-available/local.mysite.com
cd /etc/apache2/sites-enabled
ln -s ../sites-available/local.mysite.com

cp /vagrant/conf/hosts /etc/hosts

a2enmod rewrite

echo "EnableSendfile off" >> /etc/apache2/apache2.conf

# ssl configuration
mkdir -p /etc/apache2/ssl
cp /vagrant/conf/apache.crt /etc/apache2/ssl/.
cp /vagrant/conf/apache.key /etc/apache2/ssl/.

a2enmod ssl
cp /vagrant/conf/local.mysite.com-ssl /etc/apache2/sites-available/local.mysite.com-ssl
cd /etc/apache2/sites-enabled
ln -s ../sites-available/local.mysite.com-ssl



/etc/init.d/apache2 restart

cp -r /vagrant/conf/.ssh/* /home/vagrant/.ssh/.
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/*

ln -s /vagrant/conf/.composer /home/vagrant/.composer
chown -R vagrant:vagrant /home/vagrant/.composer

sudo -i -u vagrant bash -c 'cd /vagrant/site; curl -sS https://getcomposer.org/installer | php; php composer.phar install'


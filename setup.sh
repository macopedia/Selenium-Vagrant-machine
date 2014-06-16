#!/bin/sh
set -e
if [ -e /.installed ]; then
  echo 'Already installed.'

else
  echo ''
  echo 'INSTALLING'
  echo '----------'


  # Add Google public key to apt
  wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | sudo apt-key add -

  # Add Google to the apt-get source list
  echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list

  # Update app-get
  apt-get update

  # Install PHP
  apt-get -y install php5 php-apc php5-cli php5-curl php5-gd php5-imap php5-mcrypt php5-xsl php5-sqlite php-pear php5-xdebug

  # Install Java, Chrome, Xvfb, and unzip
  apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4
  apt-get -y install openjdk-7-jre google-chrome-stable xvfb unzip firefox

  # Dependencies to make "headless" chrome/selenium work
  apt-get -y install xvfb gtk2-engines-pixbuf
  apt-get -y install xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable

  # For capturing screenshots of Xvfb display
  apt-get -y install imagemagick x11-apps

  # Download and copy the ChromeDriver to /usr/local/bin
  cd /tmp
  wget "http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux32.zip"
  wget "http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar"
  unzip chromedriver_linux32.zip
  mv chromedriver /usr/local/bin
  mv selenium-server-standalone-2.42.2.jar /usr/local/bin

  # Install PHP Unit and PHP Unit Seleniun
  pear config-set auto_discover 1
  pear install pear.phpunit.de/PHPUnit
  pear install phpunit/PHPUnit_Selenium

  # So that running `vagrant provision` doesn't redownload everything
  touch /.installed
fi

# Start Xvfb, Chrome, and Selenium in the background
export DISPLAY=:10
cd /vagrant

echo "Starting Xvfb ..."
Xvfb :10 -screen 0 1366x768x24 -ac &

echo "Starting FireFox ..."
firefox &

echo "Starting Google Chrome ..."
google-chrome --remote-debugging-port=9222 &

echo "Adding local domains in /etc/hosts ..."

REMOTE_IP="192.168.2.1"
INPUT=domains.txt
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read domain
do
if [ $(grep -c " $domain" "/etc/hosts") -eq 0 ]
        then
        echo "$REMOTE_IP $domain" >> "/etc/hosts"
        fi
done < $INPUT
IFS=$OLDIFS



echo "Starting Selenium ..."
cd /usr/local/bin
nohup java -jar ./selenium-server-standalone-2.42.2.jar &


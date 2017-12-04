#!/bin/sh
# @author: Francois Menning
# Created: 04/12/2017
# Version: 1.0

# Get vars
read -p "Please enter the username: " USER

# Config
CURRENT_PATH=${PWD}
HOME_PATH='/home'
HOME_DIR_CHMOD='2755'
HOME_FILE_CHMOD='0644'
USER_PATH="$HOME_PATH/$USER"
WEBSERVER_PATH="$USER_PATH/www"
WEBSERVER_SITE_PATH='/etc/nginx/sites/'
WEBSERVER_LOG_PATH="$USER_PATH/logs"
WEBSERVER_FILE="$WEBSERVER_SITE_PATH/$USER.conf.new"
WEBSERVER_USER='http'
WEBSERVER_GROUP="$WEBSERVER_USER"
PHP_FPM_PATH='/etc/php/php-fpm.d'
PHP_FPM_FILE="$PHP_FPM_PATH/$USER.conf.new"
PHP_FPM_LISTEN="/run/php-fpm/php-fpm-$USER.sock"

# Create user
if ! id -u $USER > /dev/null 2>&1; then
   echo "$USER does not exists, creating it"
   useradd -m -s /bin/bash $USER
fi

if [ ! -d "$USER_PATH" ]; then
   echo "$USER_PATH does not exists?"
   exit
fi

# Set home permissions
chown $USER:$USER $USER_PATH
chmod $HOME_DIR_CHMOD $USER_PATH

# Allow http user access
setfacl -m "u:$WEBSERVER_USER:--x" $USER_PATH

if [ ! -d "$WEBSERVER_PATH" ]; then
   echo "Creating $WEBSERVER_PATH"
   mkdir -p $WEBSERVER_PATH
fi

# Set PHP-FPM
mkdir -p $PHP_FPM_PATH
cp $CURRENT_PATH/tpl/php-fpm.tpl $PHP_FPM_FILE
sed -i "s/@@USER@@/$USER/g" $PHP_FPM_FILE
sed -i "s/@@WEBSERVER_USER@/$WEBSERER_USER/g" $PHP_FPM_FILE
sed -i "s/@@WEBSERVER_GROUP@/$WEBSERER_GROUP/g" $PHP_FPM_FILE

# Set nginx
mkdir -p $WEBSERVER_SITE_PATH $WEBSERVER_LOG_PATH
cp $CURRENT_PATH/tpl/nginx-site.tpl $WEBSERVER_FILE
sed -i "s|@@WEBSERVER_PATH@@|$WEBSERVER_PATH|g" $WEBSERVER_FILE
sed -i "s|@@LOG_PATH@@|$WEBSERVER_LOG_PATH|g" $WEBSERVER_FILE
sed -i "s|@@PHP_FPM_LISTEN@@|$PHP_FPM_LISTEN|g" $WEBSERVER_FILE

# Set user permissions
chown -R $USER:$USER $USER_PATH
find $USER_PATH -type d -exec chmod $HOME_DIR_CHMOD {} +;
find $USER_PATH -type f -exec chmod $HOME_FILE_CHMOD {} +;

# Finish
echo "---"
echo "The user $USER has been created!"
echo "Please configure the following files:"
echo $PHP_FPM_FILE
echo $WEBSERVER_FILE

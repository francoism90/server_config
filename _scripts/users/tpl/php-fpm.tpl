[@@USER@@]
user = @@USER@@
group = @@USER@@
listen = /run/php-fpm/php-fpm-@@USER@@.sock
listen.owner = @@WEBSERVER_USER@@
listen.group = @@WEBSERVER_GROUP@@
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = /
security.limit_extensions = .php .php3 .php4 .php5 .php7
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off
php_admin_flag[expose_php] = off

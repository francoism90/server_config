[user1]
user = user1
group = user1
listen = /run/php-fpm/php-fpm-user1.sock
listen.owner = http
listen.group = http
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

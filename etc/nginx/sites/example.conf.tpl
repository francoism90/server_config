server {
   server_name www.example.com;
   include conf.d/*.conf;
   return 301 https://example.com$request_uri;
}

server {
   server_name example.com;
   include conf.d/*.conf;
   root /home/user1/www;
   access_log /home/user1/log/access.log;
   error_log /home/user1/log/error.log;
   index index.php;

   location ~ \.php$ {
     try_files $uri $document_root$fastcgi_script_name =404;
     fastcgi_pass unix:/run/php-fpm/php-fpm-user1.sock;
     fastcgi_index index.php;
     fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
     include fastcgi.conf;
   }
}

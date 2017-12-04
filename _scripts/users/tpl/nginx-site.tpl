# Redirect www
server {
   server_name <www.example.com>;
   include conf.d/*.conf;
   return 301 https://<example.com>$request_uri;
}

server {
   server_name <example.com>;
   include conf.d/*.conf;
   root @@WEBSERVER_PATH@@;
   access_log @@LOG_PATH@@/access.log;
   error_log @@LOG_PATH@@/error.log;
   index index.php index.html;

   location ~ \.php$ {
     try_files $uri $document_root$fastcgi_script_name =404;
     fastcgi_pass unix:@@PHP_FPM_LISTEN@@;
     fastcgi_index index.php;
     fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
     include fastcgi.conf;
   }
} 

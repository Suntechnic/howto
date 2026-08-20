# Поиск файлов

## За период с 1200 минут по 1190 исключая битрикс кэш
```
find ~/ext_www/ -mmin -1200 -mmin +1190 -not -path "*cache/*"
```

## Очистка от .htaccess
```
find . -name .htaccess -delete
```

## Откат изменений в гите
```
git checkout .; git clean -df;
```

## Удаление php файлов там где их быть не должно
```
find upload -name "*.php" -delete
```

## Комплексная очистка папки битрикс
```
cd bitrix
git checkout .; git clean -df;
rm -rf cache; rm -rf managed_cache;
```

## Набар признаков инфекций
eval(base64_decode
method1

## Блокировка скана в htaccess
```
    ####################################################################################################################
    # scaning block start
    RewriteRule ^test/?$        - [F,L]
    RewriteRule ^newsite/?$     - [F,L]
    RewriteRule ^site/?$        - [F,L]
    RewriteRule ^testing/?$     - [F,L]
    RewriteRule ^main/?$        - [F,L]
    RewriteRule ^restore\.php$  - [F,L]
    RewriteRule ^wp-content/.*$ - [F,L]
    RewriteRule ^wp-login\.php$ - [F,L]
    RewriteRule ^xmlrpc\.php$   - [F,L]
    RewriteRule ^phpmyadmin/    - [F,L]
    RewriteRule ^pma/           - [F,L]
    RewriteRule ^adminer\.php$  - [F,L]
    RewriteRule ^phpinfo\.php$  - [F,L]
    
    # Запретить 1–3 символьные .php в корне
    RewriteRule ^[A-Za-z0-9]{1,3}\.php$ - [F,L]

    # .env, .git, .bak, .old, дампы и бэкапы
    RewriteCond %{REQUEST_URI} "\.(env|git|svn|bak|old|sql|zip|tar|gz)$" [NC]
    RewriteRule ^.*$ - [F,L]

    # Популярные сканируемые директории/инструменты
    RewriteCond %{REQUEST_URI} "(vendor/|console/|backup/|db_backup/|installer\.php)" [NC]
    RewriteRule ^.*$ - [F,L]
    # scaning block end
    ####################################################################################################################
```

Аналогичный блок для nginx (почему-то не работает):
```
    location ~ /\. {
        deny all;
    }

    # Запрещенные пути и файлы
    location ~ ^/(test|newsite|site|testing|main)/?$            { return 403; }
    location ~ ^/(restore\.php|wp-login\.php|xmlrpc\.php)$      { return 403; }
    location ~ ^/(wp-content|wp-admin|microsoft|phpmyadmin|pma|config)/ { return 403; }
    location ~ ^/(adminer\.php|phpinfo\.php)$                   { return 403; }

    # .php с цифрами в имени
    location ~ ^.*[0-9]+.*\.php$ {
        return 403;
    }

    # Bitrix запреты
    location ~ ^/bitrix/(rk\.php|redirect\.php|spread\.php)$                            { return 403; }
    location ~ ^/bitrix/tools/(accesson\.php|composite_data\.php|spread\.php)$          { return 403; }

    # php-файлы длиной 1–3 символа в корне
    location ~ ^/[A-Za-z0-9]{1,3}\.php$ {
        return 403;
    }

    # запрет .env, .git, .bak, .old, дампов и бэкапов
    location ~* \.(env|git|svn|bak|old|sql|zip|tar|gz|conf|cfg|xz|log|db|htm)$ {
        return 403;
    }

    # популярные сканируемые директории или установщики
    location ~* (website|wordpress|wp-includes|vendor/|console/|backup/|db_backup/|installer\.php) {
        return 403;
    }

    # Блокировка нежелательных user-agent’ов
    if ($http_user_agent ~* "Go-http-client/2\.0") { return 403; }
    if ($http_user_agent ~* "python-httpx") { return 403; }
    if ($http_user_agent ~* "IbouBot") { return 403; }
```
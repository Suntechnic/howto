# Первичная настройка BitrixVm:

```sh
yum update
yum upgrade

yum install htop nano fail2ban fish composer nodejs

cp -R .ssh /home/bitrix/
chown -R bitrix:bitrix /home/bitrix/.ssh

# для композер
mv /etc/php.d/20-phar.ini.disabled /etc/php.d/20-phar.ini

# для pdo
mv /etc/php.d/20-pdo.ini.disabled /etc/php.d/20-pdo.ini
mv /etc/php.d/30-pdo_mysql.ini.disabled  /etc/php.d/30-pdo_mysql.ini

#curl
mv /etc/php.d/20-curl.ini.disabled /etc/php.d/20-curl.ini

systemctl restart httpd
```

Лечим русский в консоле:

```sh
localedef ru_RU.UTF-8 -f UTF-8 -i ru_RU
```

Отключаем вход по паролю:
```sh
nano /etc/ssh/sshd_config
# правим строку PasswordAuthentication no
systemctl restart ssh
```

Создание файла для http авторизации: htpasswd -c /etc/nginx/auth.htpasswd user

В файл nano /etc/nginx/bx/site_avaliable/s1.conf добавляем в секцию server:
```
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/auth.htpasswd;
```

Bitrix Push server 2.0 устанавливается через меню BitrixVM: 9. Configure Push/RTC service for the pool


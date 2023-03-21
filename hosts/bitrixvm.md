# Первичная настройка BitrixVm:

```sh

yum install htop nano fish composer nodejs

cp -R .ssh /home/bitrix/
chown -R bitrix:bitrix /home/bitrix/.ssh

npm install -g @bitrix/cli

yum update
yum upgrade

# для композер
mv /etc/php.d/20-phar.ini.disabled /etc/php.d/20-phar.ini

# для pdo
mv /etc/php.d/20-pdo.ini.disabled /etc/php.d/20-pdo.ini
mv /etc/php.d/30-pdo_mysql.ini.disabled  /etc/php.d/30-pdo_mysql.ini

# curl
mv /etc/php.d/20-curl.ini.disabled /etc/php.d/20-curl.ini

# xml для миграций
mv /etc/php.d/30-xmlreader.ini.disabled /etc/php.d/30-xmlreader.ini
mv /etc/php.d/20-xmlwriter.ini.disabled /etc/php.d/20-xmlwriter.ini

systemctl restart httpd
```

Лечим русский в консоле:

```sh
localedef ru_RU.UTF-8 -f UTF-8 -i ru_RU
```pw

Отключаем вход по паролю:
```sh
nano /etc/ssh/sshd_config
# правим строку PasswordAuthentication no
service sshd restart
```

Создание файла для http авторизации: htpasswd -c /etc/nginx/auth.htpasswd user

В файл nano /etc/nginx/bx/site_avaliable/s1.conf добавляем в секцию server:
```
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/auth.htpasswd;
```

Bitrix Push server 2.0 устанавливается через меню BitrixVM: 9. Configure Push/RTC service for the pool

## Мануал по настройке exim

https://www.acrit-studio.ru/pantry-programmer/knowledge-base/kak-nastroit-bitrixenv-bitrixvm-otsylat-pochtu-napryamuyu-bez-avtorizatsii-na-promezhutochnykh-pocht/

Для тестового достаточно:
```sh
yum install exim
alternatives --config mta
```
и выбираем sendmail.exim
Сделаем копию конфигурационного файла:
```sh
cp /etc/exim/exim.conf /etc/exim/exim.conf.def
```
Правим конфигурацию:
```sh
nano /etc/exim/exim.conf
```
Ищем и меняем значения у следующих директив:
```ini
primary_hostname = 123123.ru # задаем имя которое сервер будет отдавать в HELO
qualify_domain = 123123.ru # задаем имя домена, которое будет добавляться к локальным адресам, например 
```
Укажем php через какой mta отправлять почту:
```sh
nano /etc/php.d/z_bx_custom_settings.ini
```
вставялем
```ini
sendmail_path = /usr/sbin/sendmail -t -i
```
Перезапустим апач:
```sh
service httpd restart
```

## Включение swap

Swap на 4Gb
```sh
dd if=/dev/zero of=/swapfile count=4096 bs=1MiB
chmod 600 /swapfile
mkswap /swapfile
nano /etc/fstab
```
Добавляем: /swapfile   swap    swap    sw  0   0
```sh
swapon -a
```


## Когда кончились ноды диска

```sh
nano /etc/sysctl.conf
```
и добавляем в файл fs.inotify.max_user_watches = 524288
```sh
sysctl -p
sysctl --system
```
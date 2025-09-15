# Первичная настройка VDS:

## Для Ubuntu+LAMP NetAngels

```sh
# установка
apt-get update;
apt-get install screen fish htop micro;
apt-get install bindfs nodejs npm composer;
apt-get upgrade;
npm install -g @bitrix/cli

# ssh для web
cp -R .ssh/ /var/www/web/
chown -R web:web /var/www/web/.ssh
```

### Установка последний версии node
```sh
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs
```
 
[Инструкция](https://www.netangels.ru/support/cloud-vds/prebuilt/)

## HTTP Auth

Создание файла для http авторизации: htpasswd -c /etc/nginx/auth.htpasswd user

В файл nano /etc/nginx/sites-available/default-proxy добавляем в секцию server:
```
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/auth.htpasswd;
```



## Установка битрикс

Пароль БД: 
```sh 
cat /root/.my.cnf 
```

```sh
mkdir /var/www/web/sites/mysite.oceansites.ru
cd /var/www/web/sites/mysite.oceansites.ru/
wget https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php
wget https://www.1c-bitrix.ru/download/files/scripts/restore.php
```


## Создание БД

[Инструкция](../mysql/main.md)


## Изменение параметров и версий PHP

```shf
nano /etc/php/8.1/cgi/php.ini
# изменить нужные параметры и выйти
service apache2 restart
```

### Изменение версии

```sh
apt install software-properties-common
add-apt-repository ppa:ondrej/php -y
apt install php7.4
apt install php7.4-{cli,common,curl,zip,gd,mysql,xml,mbstring,json,intl}
update-alternatives --config php
```

Доустанавливаем apachemod
```sh
apt install libapache2-mod-php7.4; 
# перед этим нужно отключить другие модуля, например a2dismod php8.0
a2enmod php7.4
```
Не забываем в short_open_tag=On nano /etc/php/7.4/apache2/php.ini

### Установка сертификатов

```sh
apt install certbot python3-certbot-nginx
certbot --nginx -d mysite.ru
```

## Включение swap

Swap на 4Gb
```sh
dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
chmod 600 /swapfile
mkswap /swapfile
nano /etc/fstab
```
Добавляем: /swapfile   swap    swap    sw  0   0
```sh
swapon -a
```

## Организация совместной работы на одной площадке (на примере Netangels Ubuntu)

Если не создана группа developers ее сначала нужно создать:
```sh
groupadd developers;
gpasswd -a web developers;
```

```sh
useradd testuser; # создаем пользователя
gpasswd -a testuser developers # добавляем пользователя в группу разработчиков
mkdir /home/testuser
passwd testuser; # устанавливаем пароль

cp -r .ssh /home/testuser/.ssh; # копируем ключи рутов в папку пользователя
mkdir /home/testuser/web
cp .profile /home/testuser/.profile
cp .bashrc /home/testuser/.bashrc
usermod -s /bin/bash testuser
chown -R testuser:testuser /home/testuser; # передаем права на папку

```

Чтобы выдать права пользоваетлю на проект - создаем точку монтирования и монтируем проект
```sh
mkdir /home/testuser/web/store123.oceansites.ru # создаем папку проекта и накидываем права
chown testuser:testuser /home/testuser/web/store123.oceansites.ru

# добавляем в fstab:
bindfs#/var/www/web/sites/store123.oceansites.ru   /home/testuser/web/store123.oceansites.ru	fuse	create-for-user=web,create-for-group=web,create-with-perms=u+rwD:g=rwD:o-rwx,chmod-filter=o-rwx,perms=u+rwD:g=rwD:o-rwx,mirror=testuser,force-group=developers		0	0
```

# Удаление пользователя
Удаляем строки монтирования и перезагружаемся.  
Далее последовательно: 
```sh
passwd -l username
killall -9 -u username
deluser --remove-home username
```


# Синхронизация площадок
```sh
ssh <ПродПользователь>@<ПродАдрес> mysqldump -u <ПользовательБДПрода> -p<Пароль> <ПродБД> > dump.sql
mysql -u dev -p<Пароль> -e 'DROP DATABASE <ТестБд>;'
mysql -u dev -p<Пароль> -e 'CREATE DATABASE <ТестБд> COLLATE utf8_general_ci;'
mysql -u dev -p<Пароль> -e 'GRANT ALL PRIVILEGES ON <ТестБд>.* TO 'dev'@'localhost'; FLUSH PRIVILEGES;'
mysql -u dev -p<Пароль> <ТестБд> < dump.sql
rm dump.sql

# для переноса папок через scp
rm -rf upload
scp -r <ПродПользователь>@<ПродАдрес>:~/sites/<ПродАдрес>/upload upload

mv bitrix bitrix_old
scp -r <ПродПользователь>@<ПродАдрес>:~/sites/<ПродАдрес>/bitrix bitrix
cp bitrix_old/.settings.php bitrix/.settings.php
rm -rf bitrix_old

```

## Перенос через архив  
Команды на проде (Закомментированные копии для fish):  
```sh
# tar -zcvf upload_x_(date +%Y-%m-%d).tar.gz upload
tar -zcvf upload_x_$(date +%Y-%m-%d).tar.gz upload

# tar -zcvf bitrix_x_(date +%Y-%m-%d).tar.gz bitrix
tar -zcvf bitrix_x_$(date +%Y-%m-%d).tar.gz bitrix
```

Команды на тесте (Закомментированные копии для fish):  
```sh

```


# Установка и настройка Grafana

[Инструкция](https://grafana.com/grafana/download?edition=oss)

```sh
apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/oss/release/grafana_11.0.0_amd64.deb
dpkg -i grafana_11.0.0_amd64.deb

https://grafana.com/grafana/download?edition=oss
```

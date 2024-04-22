# Первичная настройка VDS:

## Для Ubuntu+LAMP NetAngels

```sh
# установка
apt-get install bindfs fish htop nodejs npm composer;
apt-get update;
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

```sh
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
apt install libapache2-mod-php7.4; # удалить аналогичные пакеты других версий
a2enmod php7.4
```
Не забываем в short_open_tag=On nano /etc/php/7.4/apache2/php.ini

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
mkdir /home/testuser/web/test.123123.ru # создаем папку проекта и накидываем права
chown testuser:testuser /home/testuser/web/test.123123.ru

# добавляем в fstab:
bindfs#/var/www/web/sites/test.123123.ru   /home/testuser/web/test.123123.ru	fuse	create-for-user=web,create-for-group=web,create-with-perms=u+rwD:g=rwD:o-rwx,chmod-filter=o-rwx,perms=u+rwD:g=rwD:o-rwx,mirror=testuser,force-group=developers		0	0
```
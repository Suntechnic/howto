# Первичная настройка VDS:

## Для Ubuntu+LAMP NetAngels

```sh
# установка
apt-get update;
apt-get install fish htop nodejs npm;
apt-get upgrade;

# ssh для web
cp -R .ssh/ /var/www/web/
chown -R web:web /var/www/web/.ssh
```
 
[Инструкция](https://www.netangels.ru/support/cloud-vds/prebuilt/)


## Установка битрикс

```sh
mkdir /var/www/web/sites/mysite.oceansites.ru
cd /var/www/web/sites/mysite.oceansites.ru/
wget https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php
```


## Создание БД

[Инструкция](../mysql/main.md)


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

## Организация совместной работы на одной площадке (на примере Netangels Ubuntu)

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
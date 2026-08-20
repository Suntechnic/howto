# Первичная настройка VDS4Proxy:

```sh
# установка
apt-get update;
apt-get upgrade;
apt-get install ufw git fish htop micro nano iptables fail2ban;

# меняем имя
micro /etc/hostname

mkdir ~/.ssh; nano ~/.ssh/authorized_keys

# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnZxKT7fVHA93npUq7gqp7MXOIpq4j570i7U8bVst/srKBTChFOLqPm60Jh41ziVe+bFwqakLROGynvgkkpesAKFggp38OLJx6S0y1keY3ubnecG5Gtu3NpdTBa1SfcuXLQkYrF+K8twbHDPcPOc3ilsI3Qml45eaX0uUcyA2VqvVAknje2cB/5zyVdTn+2yAlTpUyyDlpu0fRTKgANecCO9f62pd4QXPuqmvykdh0md2g7jFQjttUaRO6y3DySGhPng4tox80DyrG87GxL+yrCR2Nvw+SD1Mb9n3940KprD8RoOy/u9DkUUrgzkrY5h7J9AWkNJk36nzA+spi7jpF alex@alex-thinkpad
```

настраиваем ssh - порт и отключаем вход по паролю
```sh
micro /etc/ssh/sshd_config
```

## Настройка безопасности:

```sh
ufw allow 3333
ufw allow 443
ufw allow 1180
ufw enable
```

## Настройка dante:

```sh
apt-get install dante-server
micro /etc/danted.conf

```

```
# Путь к лог файлу
#logoutput: /socks.log
# Можно задать отдельный лог файл для ошибок
#errorlog: /socks_error.log

internal: 0.0.0.0 port=1180
external: eth0

##Тип авторизации
#Работа без пароля
#socksmethod: none
#Авторизация по локальным/системным пользователям (наш случай)
socksmethod: username
#Авторизация при помощи логина/пароля, сохраняемого в PAM-файле:
#socksmethod: pam.username


# Мы используем системных пользователей, поэтому нужны права на чтение passwd
user.privileged: root
user.unprivileged: nobody
user.libwrap: nobody

# Разрешить подключения с любых IP всем пользователям прошедшим авторизацию
client pass {
        from: 0/0 to: 0/0
        log: connect disconnect error ioop
}

socks pass {
        from: 0/0 to: 0/0
        log: connect disconnect error ioop
}


```

```sh
useradd --shell /usr/sbin/nologin proxyuser
passwd proxyuser
```
Пароль 8009_Tango
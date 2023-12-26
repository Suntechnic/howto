# Первичная настройка VDS4VPN:

```sh
# установка
apt-get update;
apt-get upgrade;
apt-get install xclip python3-pip ufw wireguard git fish htop micro nano iptables;

mkdir ~/.ssh; nano ~/.ssh/authorized_keys

# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnZxKT7fVHA93npUq7gqp7MXOIpq4j570i7U8bVst/srKBTChFOLqPm60Jh41ziVe+bFwqakLROGynvgkkpesAKFggp38OLJx6S0y1keY3ubnecG5Gtu3NpdTBa1SfcuXLQkYrF+K8twbHDPcPOc3ilsI3Qml45eaX0uUcyA2VqvVAknje2cB/5zyVdTn+2yAlTpUyyDlpu0fRTKgANecCO9f62pd4QXPuqmvykdh0md2g7jFQjttUaRO6y3DySGhPng4tox80DyrG87GxL+yrCR2Nvw+SD1Mb9n3940KprD8RoOy/u9DkUUrgzkrY5h7J9AWkNJk36nzA+spi7jpF alex@alex-thinkpad
```

настраиваем ssh - порт и отключаем вход по паролю

## Настройка безопасности:

```sh
ufw allow 3333
ufw enable
```

## Настройка Wireguard:

Установка wirefuard:
```sh
# Генерируем ключи сервера:
wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey

# Ставим права для приватного ключа:
chmod 600 /etc/wireguard/privatekey

# узнаем интерфейс:
ip route list default
# default via 176.126.113.1 dev eth0 onlink
# в данном случае это eth0

# Создаем конфигурацию сервера:
nano /etc/wireguard/wg0.conf

# Вставляем в файл. По умолчанию интерфейс eth0:
[Interface]
Address = 10.77.77.1/24 # нyжная подсесть
Address = fd42:48:48::1/64 # нyжная подсест 6
PostUp = iptables -A FORWARD -i eth0 -o wg0 -j ACCEPT; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i eth0 -o wg0 -j ACCEPT; iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 53516
PrivateKey = # ключ


# Настраиваем IP форвардинг:
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf sysctl -p
# .... и перезагрузить

# разрешаем порт
ufw allow 53516/udp

# запускаем
systemctl enable wg-quick@wg0.service
service wg-quick@wg0 start
```

Установка WG-Dashboard
```sh
git clone -b v3.1-dev https://github.com/donaldzou/WGDashboard.git wgdashboard

# Открываем папку
cd wgdashboard/src

# Устанавливаем WGDashboard
chmod u+x wgd.sh
pip install -r requirements.txt
./wgd.sh install

# Меняем права для папки с конфигом
chmod -R 755 /etc/wireguard

# Запускаем WGDashboard
./wgd.sh start

ufw disable
```

После заходим в интрефейс на проту 10086 и в настройках изменяем пароль


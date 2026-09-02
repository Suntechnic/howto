# Настройка стандартного окружения


## 1. Установить пакеты

Выполняется от root-пользователя. Установка пакетов для работы с zsh, git, screen, htop, micro, nodejs, npm, composer и bindfs. Также устанавливается Bitrix CLI.

```bash
apt-get update
apt-get install -y zsh git screen htop micro;
```

Пакеты для сервера разработки:
```bash
apt-get install nodejs npm composer; # дополнительно для разработки
apt-get install bindfs; # для нескольких пользователей на одном сайте
npm install -g @bitrix/cli; # для разработки на Битрикс

```

## 2. Установить zsh

Выполняется от пользователя

```bash
wget https://raw.githubusercontent.com/Suntechnic/howto/refs/heads/main/hosts/files/.zshrc -O ~/.zshrc;
```

## 3. Настройка прокси

Создаем файл ~/.vscode-server-insiders/server-env-setup и добавляем в него настройки прокси:

```bash
export HTTPS_PROXY='http://user:MdP_83JkadQL@partsdevice.ru:3128'
export HTTP_PROXY="$HTTPS_PROXY"
export https_proxy="$HTTPS_PROXY"
export http_proxy="$HTTP_PROXY"
```

## 4. Установить GitHub Copilot CLI

Установка GitHub Copilot CLI на Linux, вначале экспортировав переменные прокси из файла ~/.vscode-server-insiders/server-env-setup.

```zsh
source ~/.vscode-server-insiders/server-env-setup; curl -fsSL https://gh.io/copilot-install | bash
```
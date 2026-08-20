# Настройка стандартного окружения


## 1. Установить пакеты

Выполняется от root-пользователя. Установка пакетов для работы с zsh, git, screen, htop, micro, nodejs, npm, composer и bindfs. Также устанавливается Bitrix CLI.

```bash
apt-get update
apt-get install -y zsh git screen htop micro;
apt-get install nodejs npm composer; # дополнительно для разработки
apt-get install bindfs; # для нескольких пользователей на одном сайте
npm install -g @bitrix/cli; # для разработки на Битрикс

```

## 2. Установить плагины для zsh

Выполняется от пользователя

Создайте каталог плагинов и скачайте два официальных community-плагина:

```bash
mkdir -p ~/.config/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting
```

Назначение плагинов:

- `zsh-autosuggestions` — показывает серое продолжение команды по истории и completion, аналогично fish.
- `zsh-syntax-highlighting` — подсвечивает команду, аргументы, пути и очевидные ошибки ещё до нажатия Enter.

Добавьте в `~/.zshrc` настройки содержимое [файла](files/.zshrc) и перезапустите zsh:

```bash
wget https://raw.githubusercontent.com/Suntechnic/howto/refs/heads/main/hosts/files/.zshrc -O ~/.zshrc
source ~/.zshrc
```

## 3. Установить GitHub Copilot CLI

Установка GitHub Copilot CLI на Linux:

```zsh
HTTP_PROXY='http://LOGIN:PASS@213.139.222.86:9935' HTTPS_PROXY='http://LOGIN:PASS@213.139.222.86:9935' curl -fsSL https://gh.io/copilot-install | bash
```
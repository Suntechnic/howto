## Команды для полного удаления git сабмодуля:

Удалить секцию модуля из .gitmodules
Выполнить команду git add .gitmodules
Удалить модуль из .git/config
Выполнить команду git rm -rf --cached path_to_submodule чтобы удалить директорию из индекса
Выполнить команду rm -rf .git/modules/path_to_submodule
Выполнить коммит git commit -m "Removed submodule <name>"
Выполнить команду rm -rf path_to_submodule чтобы удалить "неотслеживаемые" файлы подмодуля

## Персональные ключи деплоя

Генерируем ключи, с разными именаме вида id_rsa_{названиеПроекта}

Создаем файл .ssh/config вида:
```
Host github.com-{названиеПроекта}
        Hostname github.com
        IdentityFile=/home/bitrix/.ssh/id_rsa-{названиеПроекта}
Host github.com-{названиеПроекта}
        Hostname github.com
        IdentityFile=/home/bitrix/.ssh/id_rsa-{названиеПроекта}
Host github.com-{названиеПроекта}
        Hostname github.com
        IdentityFile=/home/bitrix/.ssh/id_rsa-{названиеПроекта}
```

Не забыть chmod g-w ~/.ssh/config


## Откат всех изменений

```
git checkout .; git clean -df;
```



## Конфигурация 

```sh
git config --global user.email "madzhugin@gmail.com"
git config --global user.name "Александр Маджугин"
```

Отменить все незакомиченные изменения
```sh
git reset --hard
```

## Gitignore для Bitrix в папке /bitrix
```
/backup
/cache
/managed_cache
/stack_cache
/tmp
/images
/fonts
```

## Gitignore для Bitrix
```
#Test 
/_tools
/_test
/_devzone

#IDE
.idea/

# Exclude files
/.htaccess
.htaccess
/.htsecure
.htsecure
/*.sql
/*.xml
*.log
*.sql
*.tar.gz
*.txt
/.svn
*~

#Bitrix core & data
#core
/bitrix
/upload

#data
/local/.logs
```
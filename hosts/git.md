## Удаление git подмодуля (submodule)

```bash
# Удаляем подмодуль
git submodule deinit -f path/to/submodule
git rm -f path/to/submodule
git commit -m "Removed submodule path/to/submodule"

# Удаляем директорию из .git/modules (опционально)
rm -rf .git/modules/path/to/submodule
```

## Персональные ключи деплоя

Генерируем ключи, с разными именаме вида id_rsa-{названиеПроекта}

Создаем файл ~/.ssh/config вида:
```
Host github.com-{названиеПроекта}
        Hostname github.com
        IdentityFile=/home/bitrix/.ssh/id_rsa-{названиеПроекта}
Host github.com-{названиеПроекта}
        Hostname github.com
        IdentityFile=/var/www/web/.ssh/id_rsa-{названиеПроекта}
```

Не забыть chmod g-w ~/.ssh/config

Далее для нужного сабмодуля выполняем команду:
git config submodule.{путьКподмодулю}.url git@github.com-{названиеПроекта}:{владелец}/{проект}.git  
К примеру: git config submodule.local/assets.url git@github.com-assets:aseven77/dsrvd.git для подмодуля local/assets и репозитория git@github.com:aseven77/dsrvd.git


## Откат всех изменений

```
git checkout .; git clean -df;
```



## Конфигурация 

```sh
git config --global user.email "email@gmail.com"
git config --global user.name "Разработчик"
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
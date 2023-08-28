# X


## Получаем шаблоны

В /home/bitrix:
```sh
git clone git@github.com:Suntechnic/x.git
cp x/.gitignore www/
cp -R x/test www/
mkdir www/local
cp -R x/local/php_interface www/local
cp -R x/local/templates www/local
```

## Инициализируем .git

```
rm -rf images/
git init;
git add --all .;
git config --global user.email "madzhugin@gmail.com"
git config --global user.name "Александр Маджугин"
git commit -m "first commit"; 
git branch -M main;

git remote add origin тут_адрес_репы

git push -u origin main
```

## Сабмодули

обавляем xCore:
```bash
git submodule add git@github.com:Suntechnic/xBxx.git local/php_interface/lib/Bxx
```
Устанавливаем модуль в админке

Закидываем xComponents:
```bash
git submodule add git@github.com:Suntechnic/xComponents.git local/components/x
```

Закидываем xExtensions:
```bash
git submodule add git@github.com:Suntechnic/xExtensions.git local/js/x
```

## Устанавливаем модули composer

Обязательно редактируем composer.json заменяя Test/test на название проекта.

При необходимости включить от root нужные модулю.
В битриксVM

```json
{
    "name": "vendor/project",
    "type": "project",
    "autoload": {
        "psr-4": {
                "App\\": "lib/App",
                "Bxx\\": "lib/Bxx"
            }
    },
    "require-dev": {
        "kint-php/kint": "dev-master"
    }
}
```

```bash
cd local/php_interface;
composer update;
cd -
```

## init.php:

```php
<?php

if ($_SERVER['APPLICATION_ENV']) {
    define('APPLICATION_ENV',$_SERVER['APPLICATION_ENV']);
} else {
    define('APPLICATION_ENV','production');
}

require __DIR__ . '/vendor/autoload.php';

\Kint\Renderer\RichRenderer::$folder = true;
if (!defined('APPLICATION_ENV') || APPLICATION_ENV != 'dev') {
    \Kint::$enabled_mode = false;
} else if (defined('APPLICATION_ENV') || APPLICATION_ENV != 'production') {
    define('VUEJS_DEBUG', true);
}
```


Добавляем вертску:
```bash
git submodule add тут_репа_верстки local/assets
```

## Если необходимо изменить параметры загрузки ядра или установить какие-то параметры до загрузки, а так же выполнить обработку, например переключение языков:

1 В /bitrix добавляем файл .settings_extra.php со следующим содержимым:
```
<?return include_once($_SERVER['DOCUMENT_ROOT'].'/local/.settings_extra.php');
```

2 В /local добавляем файл .settings_extra.php с необходимыми действиями.
Файл должен возвращать массив.
Например:
```
if ('en.cytamin.123123.ru' == $_SERVER['SERVER_NAME']) {
    define('LANGUAGE_ID','en');
    define('LANG_CHARSET','en');
} /* else {
    define('LANGUAGE_ID','ru');
    define('LANGUAGE_ID','ru');
} */

return array ();
```

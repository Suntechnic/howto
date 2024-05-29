# X


## Получаем шаблоны

В документрут:
```sh
git clone git@github.com:Suntechnic/x.git ../x
cp ../x/.gitignore ./
cp -R ../x/test ./
mkdir ./local
cp -R ../x/local/php_interface ./local
cp -R ../x/local/templates ./local
```

## Инициализируем .git

```sh
rm -rf images/

git config --global user.email "madzhugin@gmail.com"
git config --global user.name "Александр Маджугин"

git init;
git add --all .;
git commit -m "first commit"; 
git branch -M main;

git remote add origin тут_адрес_репы

git push -u origin main
```

## Сабмодули

обавляем xCore:
```bash
# git submodule add git@github.com:Suntechnic/xBxx.git local/php_interface/lib/Bxx
git submodule add https://github.com/Suntechnic/xBxx.git local/php_interface/lib/Bxx
```

Закидываем xComponents:
```bash
git submodule add git@github.com:Suntechnic/xComponents.git local/components/x
```

Закидываем xExtensions:
```bash
#git submodule add git@github.com:Suntechnic/xExtensions.git local/js/x
git submodule add https://github.com/Suntechnic/xExtensions.git local/js/x
```

Добавляем вертску:
```bash
git submodule add тут_репа_верстки local/assets
```

### обновление сабмодулей:
```bash
git submodule foreach 'git pull'
```

## Устанавливаем модули composer

Обязательно редактируем composer.json заменяя vendor/project на название проекта.

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

if ($_SERVER['APPLICATION_ENV'] || $_SERVER['REDIRECT_APPLICATION_ENV']) {
    if (!$_SERVER['APPLICATION_ENV']) $_SERVER['APPLICATION_ENV'] = $_SERVER['REDIRECT_APPLICATION_ENV'];
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

$DefaultTemplatePath = \Bitrix\Main\Application::getDocumentRoot().'/local/templates/.default';
define('DEFAULT_TEMPLATE_PATH',$DefaultTemplatePath);

// подгрузка всего из папки init
$lstInitsFile = array_filter(scandir(__DIR__.'/init'),function ($N) {return (
        substr($N,-4) == '.php'
    );});
if ($lstInitsFile) foreach ($lstInitsFile as $FileName) include(__DIR__.'/init/'.$FileName);
```

При этом в .htaccess добавляем *SetEnv APPLICATION_ENV 'dev'*


## Если необходимо изменить параметры загрузки ядра или установить какие-то параметры до загрузки, а так же выполнить обработку, например переключение языков:

1 В /bitrix добавляем файл .settings_extra.php с инклюдом данных из local:
```php
<?
include_once($_SERVER['DOCUMENT_ROOT'].'/local/.settings_extra.php');

// в ретарн можно дописать собственны параметры, чтобы не смешиваться с говном из /bitrix/.settings.php
return array (
        'routing' => [
                'value' => [
                        'config' => ['api.php','web.php']
                    ]
            ]
    );
```

2 В /local добавляем файл .settings_extra.php с необходимыми действиями.
Файл должен возвращать массив.
Например:
```php
if ('en.cytamin.123123.ru' == $_SERVER['SERVER_NAME']) {
    define('LANGUAGE_ID','en');
    define('LANG_CHARSET','en');
} /* else {
    define('LANGUAGE_ID','ru');
    define('LANGUAGE_ID','ru');
} */
```

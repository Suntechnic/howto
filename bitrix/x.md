# X

## Инициализируем .git

Закидываем gitignore:
```
rm -rf images/
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

Добавляем вертску:
```bash
git submodule add тут_репа_верстки local/assets
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

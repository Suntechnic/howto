# Поиск файлов

## За период с 1200 минут по 1190 исключая битрикс кэш
```
find ~/ext_www/ -mmin -1200 -mmin +1190 -not -path "*cache/*"
```

## Очистка от .htaccess
```
find . -name .htaccess -delete
```

## Откат изменений в гите
```
git checkout .; git clean -df;
```

## Удаление php файлов там где их быть не должно
```
find upload -name "*.php" -delete
```

## Комплексная очистка папки битрикс
```
cd bitrix
git checkout .; git clean -df;
rm -rf cache; rm -rf managed_cache;
```

## Набар признаков инфекций
eval(base64_decode
method1


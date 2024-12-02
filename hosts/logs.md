```sh
cat /var/log/nginx/itsklad.access.log | grep "/bitrix/admin/1c_" | sed "/$217.11.65.214/d"
```
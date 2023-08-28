# MySQL

Создание новой БД
```sql
DROP USER username@localhost;
DROP DATABASE dbname;
CREATE USER username@localhost IDENTIFIED BY 'uRfeADdxZTghst3E';
CREATE DATABASE dbname COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON dbname.* TO 'username'@'localhost'; FLUSH PRIVILEGES;
quit;
```
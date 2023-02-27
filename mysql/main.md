# MySQL

```sql
DROP USER user@localhost;
DROP DATABASE dbname;
CREATE USER user@localhost IDENTIFIED BY 'JKhfhryu3yH';
CREATE DATABASE dbname COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON dbname.* TO 'user'@'localhost'; FLUSH PRIVILEGES;
quit;
sql
```
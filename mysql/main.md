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

Простая выборка
```sql
SELECT * FROM b_sale_discount_coupon WHERE DISCOUNT_ID=232;
```

Замена купонов правил корзины
```sql
UPDATE b_sale_discount_coupon SET DISCOUNT_ID=269 WHERE DISCOUNT_ID=270;
```

Перенос значения свойств
```sql
UPDATE b_iblock_element_property SET IBLOCK_PROPERTY_ID=580 WHERE IBLOCK_PROPERTY_ID=106;
```

# Параметры сервера для bitrix

```
[mysqld]
transaction-isolation = READ-COMMITTED
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
thread_cache_size = 4
```

# Поиск строки в БД

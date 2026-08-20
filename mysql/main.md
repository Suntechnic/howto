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

Пример добавления купонов
```sql
INSERT INTO b_sale_discount_coupon (DISCOUNT_ID, TYPE, ACTIVE, MAX_USE, USE_COUNT, USER_ID, COUPON) VALUES
(351, 4, 'Y', 0, 0, 0, 'PAN001'),
(351, 4, 'Y', 0, 0, 0, 'PAN003'),
(351, 4, 'Y', 0, 0, 0, 'PAN009'),
(351, 4, 'Y', 0, 0, 0, 'PAN016');
```

Перенос значения свойств
```sql
UPDATE b_iblock_element_property SET IBLOCK_PROPERTY_ID=580 WHERE IBLOCK_PROPERTY_ID=106;
```

Про
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

# Ошибки в кодировке таблиц

Для начала сгенерируем запросы на исправления:  
Тут вместо ИмяБазы должно быть имя базы, а вместо utf8mb4_general_ci - {ПроблемнаяКодировка}_general_ci
```sql
SELECT CONCAT('ALTER TABLE `', t.`TABLE_SCHEMA`, '`.`', t.`TABLE_NAME`, '` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;') as sqlcode
FROM `information_schema`.`TABLES` t
WHERE 1
AND t.`TABLE_SCHEMA` = 'ИмяБазы'
AND t.`TABLE_COLLATION` = 'utf8mb4_general_ci'
ORDER BY 1
```
Далее выполняем сгенерированные запросы
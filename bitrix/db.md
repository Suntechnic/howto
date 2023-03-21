# База данных битрикс

## Очистка пользовательских данных

На основании (bx_remove_personal_data)[https://gist.github.com/webarchitect609/8b979833aa8f2b5f7bf9a058528ac9ac]

```sql
-- Удалить все свойства корзины, которые связаны с корзинами, которые связаны с заказами, вместе с этими корзинами и заказами
-- ATTENTION! Этот запрос ОЧЕНЬ долгий. Соединение с базой может отвалиться по таймауту!
-- TODO Попытаться добавить защиту от долго выполняющегося запроса.
delete BP, B, O
from b_sale_basket_props as BP
inner join b_sale_basket as B
	on BP.BASKET_ID = B.ID
inner join b_sale_order as O
	on B.ORDER_ID = O.ID
where B.ORDER_ID is not null;

-- Удалить все корзины, которые связаны с заказами(на всякий случай)
delete from b_sale_basket where ORDER_ID is not null;

-- Очистить статистику покупок
truncate b_sale_buyer_stat;

-- Очистить все сохранённые профили пользователей
truncate b_sale_user_props_value;

-- Удалить все значения свойств заказов
truncate b_sale_order_props_value;

-- Удалить все заказы
truncate b_sale_order;

-- Удалить все архивные заказы
truncate b_sale_order_archive;

-- Удалить все архивные корзины
truncate b_sale_basket_archive;

-- Удалить все архивы корзин(не ясно, что это, но тоже удалить)
truncate b_sale_basket_archive_packed;

-- Собрать id пользователей, входящих во все остальные группы и сохранить их во временной таблице.
create temporary table if not exists `tmp_keep_users_id_list` (`ID` int(18) NOT NULL);
truncate `tmp_keep_users_id_list`;
insert into `tmp_keep_users_id_list` (
	select U.ID
	from b_user as U
	inner join b_user_group as UG
		on U.ID = UG.USER_ID
	where
		UG.GROUP_ID in(
			-- TODO Отредактировать под свой проект.
			-- Выбрать ID групп пользователей, которые будут сохранены(но за исключением системной [2] "Все пользователи").
			select ID from b_group where ID <> 2 and ID not in(6)
		)
		-- захватить служебную запись админа - её ни при каких условиях нельзя удалять
		or U.ID = 1
	group by U.ID
);

-- Удалить всех пользователей кроме тех, которых надо сохранить, вместе со всеми связанными данными.
delete from b_user where ID not in(select * from tmp_keep_users_id_list);
delete from b_uts_user where VALUE_ID not in(select * from tmp_keep_users_id_list);
delete from b_rating_user where ENTITY_ID not in(select * from tmp_keep_users_id_list);
delete from b_user_group where USER_ID not in(select * from tmp_keep_users_id_list);
delete from b_user_access where USER_ID not in(select * from tmp_keep_users_id_list);
delete from b_user_access_check where USER_ID not in(select * from tmp_keep_users_id_list);
delete from b_user_option where USER_ID not in(select * from tmp_keep_users_id_list);

-- Удалить временную таблицу.
drop temporary table `tmp_keep_users_id_list`;

-- Удалить пользователей, которые вообще ни в какие группы не входят(на всякий случай; вдруг таблица битая)
delete U
from b_user as U
left join b_user_group as UG
	on U.ID = UG.USER_ID
where UG.USER_ID is null;

-- Удалить значения пользовательских полей пользователя, которые более ни к какому пользователю не привязаны.
delete UTS
from b_user as U
right join b_uts_user as UTS
	on U.ID = UTS.VALUE_ID
where U.ID is null;

-- Удалить Fuser, которые не привязаны ни к какому пользователю или же анонимные.
delete FU
from b_sale_fuser as FU
left join b_user as U
	on FU.USER_ID = U.ID
where
	U.ID is null;

-- TODO Удалить ответы модуля "Веб-формы".

-- Замер количества, чтобы увидеть результат
select count(*) as ORDER_CNT
from b_sale_order;

select count(*) as BASKET_CNT
from b_sale_basket;

select count(*) as FUSER_CNT
from b_sale_fuser;

select count(*) as USER_CNT
from b_user;
```
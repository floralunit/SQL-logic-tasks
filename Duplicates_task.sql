--Дано:
--В таблице t, только одно поле [a] с символьными данными, значения неуникальны.
--select a from t
--Требуется:
--Создать в одном запросе список с уникальными данными на основе поля [a], добавляя в конец поля числовой номер номер дубликата.

--**1. Необходимо сохранить первоначальный порядок записей основываясь на поле [i].
--2. Добавьте новое поле [Cnt], которое будет показывать сколько записей вывелось в запросе. Проверять буду
--фильтрацией where
--Результат должен быть таким:
--i a Field cnt
--1 ccc ccc 9
--2 fff fff 9
--3 eee eee 9
--4 aaa aaa 9
--5 bbb bbb 9
--6 ccc ccc2 9
--7 ccc ccc3 9
--8 bbb bbb2 9
--9 aaa aaa2 9
--если я добавлю к запросу where a=’ccc’, то результат должен быть следующим:
--i a field cnt
--1 ccc ccc 3
--6 ccc ccc2 3
--7 ccc ccc3 3

select
i,a,
case when ROW_NUMBER() OVER (PARTITION BY a ORDER BY a) = 1 then a else a +
CAST(ROW_NUMBER() OVER
(PARTITION BY a ORDER BY a ) as char(10)) end as field,
count(*) over () as cnt
from
(values
(1, 'ccc')
,(2, 'fff')
,(3, 'eee')
,(4, 'aaa')
,(5, 'bbb')
,(6, 'ccc')
,(7, 'ccc')
,(8, 'bbb')
,(9, 'aaa')
) as t (i,a)
order by i
--Дано:
--В таблице Client "Клиенты" хранятся все данные контрагентов.
--Client.ID - Уникальный номер записи в таблице "Клиенты"
--Client.Tel_Mob1 - Номер телефона для связи № 1(тип nvarchar)
--Client.Tel_Mob2 - Номер телефона для связи № 2(тип nvarchar)
--Client.Tel_Mob3 - Номер телефона для связи № 3(тип nvarchar)
--Переменная @ID - Хранится ID контрагента таблице Client "Клиенты"(пример связки: Client.ID = @ID)
--Требуется:
--Создать в одном запросе вывод всех номеров телефонов для связи в карточке контрагента, убирая дубликаты и пустые поля, для всей таблицы контрагентов.
--Пример преобразования:
--на входе:
--Tel_Mob1 = NULL
--Tel_Mob2 = '+7(926)777-00-01'
--Tel_Mob3 = '+7(926)777-00-01'
--На выходе:
--Tel_Mob1 = '+7(926)777-00-01'
--Tel_Mob2 = NULL
--Tel_Mob3 = NULL
--**Для правильного решения, предлагаю увеличить кол-во полей с телефонами, например, пусть будет их 5 (пять) 
--и для поиска правильного пути, пусть они будут выведены по возрастанию.

with t1 as (
select Id, Tel_Mob1 AS Tel_Mob from Client where Tel_Mob1 is not NULL
union
select Id, Tel_Mob2 AS Tel_Mob from Client where Tel_Mob2 is not NULL
union
select Id, Tel_Mob3 AS Tel_Mob from Client where Tel_Mob3 is not NULL
union
select Id, Tel_Mob4 AS Tel_Mob from Client where Tel_Mob4 is not NULL
union
select Id, Tel_Mob5 AS Tel_Mob from Client where Tel_Mob5 is not NULL
),
t2 as (
select *, ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) AS row
from t1
)
select Id,
(select Tel_Mob from t2 where t2.row=1 and t2.Id = Client.Id) as Tel_Mob1,
(select Tel_Mob from t2 where t2.row=2 and t2.Id = Client.Id) as Tel_Mob2,
(select Tel_Mob from t2 where t2.row=3 and t2.Id = Client.Id) as Tel_Mob3,
(select Tel_Mob from t2 where t2.row=4 and t2.Id = Client.Id) as Tel_Mob4,
(select Tel_Mob from t2 where t2.row=5 and t2.Id = Client.Id) as Tel_Mob5
from Client
order by Tel_Mob5,Tel_Mob4, Tel_Mob3, Tel_Mob2, Tel_Mob1

--2 вариант (неудачный) с 3-мя телефонами
select
ISNULL(ISNULL(Tel_Mob1, Tel_Mob2), Tel_Mob3) AS Tel_Mob1,
CASE WHEN ISNULL(ISNULL(Tel_Mob1, Tel_Mob2), Tel_Mob3) = Tel_Mob2 THEN (CASE WHEN
Tel_Mob2 = Tel_Mob3 OR Tel_Mob3 IS NULL THEN NULL ELSE Tel_Mob3 END)
ELSE (CASE WHEN ISNULL(ISNULL(Tel_Mob1, Tel_Mob2), Tel_Mob3) = Tel_Mob3 THEN NULL
ELSE (CASE WHEN Tel_Mob1 <> Tel_Mob2 THEN ISNULL(Tel_Mob2, Tel_Mob3)
ELSE (CASE WHEN Tel_Mob1 <> Tel_Mob3 THEN Tel_Mob3 ELSE NULL END)

END) END) END AS Tel_Mob2,
CASE WHEN Tel_Mob1 IS NULL OR Tel_Mob2 IS NULL OR Tel_Mob1 = Tel_Mob3 OR Tel_Mob2 =
Tel_Mob3 THEN NULL ELSE Tel_Mob3 END AS Tel_Mob3
from Client
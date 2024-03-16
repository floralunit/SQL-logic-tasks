--разделить данные из одной колонки равномерно в 2 колонки

select column1, column2 
from 
(select 
  ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as rn
, case when ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 2 = 1 then a end AS column1 
from t) as p1
left join
(select 
  ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as rn
, case when ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 2 = 0 then a end AS column2 
from t)as p2
on p2.rn = p1.rn +1
where column1 is not null

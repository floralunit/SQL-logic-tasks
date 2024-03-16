-- используя order by соединить 2 таблицы и вывести полное наименование документа, с учетом, что для некоторых проектов есть исключения по наименованию,
-- которые нельзя (тупо) проверять через where и case

select Project, TT, t2.TT_NameDoc
from
(values 
  ('JLR','ЗР')
 ,('GAC','АВР')
 ,('GAC2','АВР')
 ,('GAC','ЗР')
 ,('Aurus','ЗР')
) as t (Project, TT)
cross apply (
    select top 1 *
    from 
  (values 
  (null,'ЗР','Заявка')
 ,(null,'ЗН','Заказ-наряд')
 ,(null,'ПЗН','Предварительный заказ-наряд')
 ,(null,'ВЗН','Внутренний заказ-наряд')
 ,(null,'ГЗН','Гарантийный заказ-наряд')
 ,(null,'СЗН','Заказ-наряд')
 ,(null,'АВР','Акт выполненных работ к заказ-наряду')
 ,(null,'ГАВР1','Гарантийный акт выполненных работ к заказ-наряду')
 ,(null,'ГАВР2','Гарантийный акт выполненных работ к заказ-наряду')
 -- исключения от стандарта
, ('GAC','ЗР','Заявка на выполнение работ') 
) as tt_info (TT_Project, TT_abr, TT_NameDoc)
where tt_info.TT_abr = t.TT or t.TT is null
--order by case when tt_info.TT_Project=t.Project then 1 else case when tt_info.TT_Project is null then 0 end end desc
order by case when tt_info.TT_Project<>t.Project then 1 end 
) t2
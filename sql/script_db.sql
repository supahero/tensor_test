with customer_json (doc) as (
   values
    ('[{
"id": 1,
"ParentId": null,
"Name": "Офис в Санкт-Петербурге",
"Type": 1
},
{
"id": 2,
"ParentId": 1,
"Name": "Отдел разработки",
"Type": 2
},
{
"id": 3,
"ParentId": 2,
"Name": "Иванов",
"Type": 3
},
{
"id": 4,
"ParentId": 2,
"Name": "Сидоров",
"Type": 3
},
{
"id": 5,
"ParentId": 1,
"Name": "Отдел тестирования",
"Type": 2
},
{
"id": 6,
"ParentId": 5,
"Name": "Петров",
"Type": 3
},
{
"id": 7,
"ParentId": null,
"Name": "Офис в Москве",
"Type": 1
},
{
"id": 8,
"ParentId": 7,
"Name": "Аналитический отдел",
"Type": 2
},
{
"id": 9,
"ParentId": 8,
"Name": "Винтиков",
"Type": 3
},
{
"id": 10,
"ParentId": 8,
"Name": "Шпунтиков",
"Type": 3
},
{
"id": 11,
"ParentId": 7,
"Name": "Отдел продаж",
"Type": 2
},
{
"id": 12,
"ParentId": 11,
"Name": "Отдел обслуживания корпоративных клиентов",
"Type": 2
},
{
"id": 13,
"ParentId": 12,
"Name": "Белова",
"Type": 3
},
{
"id": 14,
"ParentId": 12,
"Name": "Крылова",
"Type": 3
},
{
"id": 16,
"ParentId": 11,
"Name": "Отдел обслуживания физ лиц",
"Type": 2
},
{
"id": 17,
"ParentId": 16,
"Name": "Петрова",
"Type": 3
},
{
"id": 18,
"ParentId": 16,
"Name": "Иванова",
"Type": 3
},
{
"id": 19,
"ParentId": 7,
"Name": "Тех. поддержка",
"Type": 2
},
{
"id": 20,
"ParentId": 19,
"Name": "Морозов",
"Type": 3
}]
'::json)
)
insert into staff ("id", "ParentId", "Name", "Type")
select p.*
from customer_json l
  cross join lateral json_populate_recordset(null::staff, doc) as p
on conflict (id) do update
  set name = excluded.name,
      comment = excluded.comment;
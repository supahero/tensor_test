import settings
import psycopg2

try:
    connection = psycopg2.connect(user=settings.DB_user,
                                  password=settings.DB_password,
                                  host=settings.DB_host,
                                  port=settings.DB_port,
                                  database=settings.DB_name)
    cur = connection.cursor()

except (Exception, psycopg2.Error) as error:
    print("Error: ", error)
else:
    number = input('Введите id сотрудника: ')
    if number.isdigit() is False:
        raise ValueError("Ошибка. Необходимо ввести число")
    else:
        cur.execute("""SELECT
  --проверка, что на входе type сотрудника
  CASE WHEN (SELECT staff."Type" from staff where id = %s) != 3 THEN 'Данный id не принадлежит сотруднику. Проверьте 
  правильность ввода'
       WHEN (SELECT staff."Type" from staff where id = %s) = 3 THEN (
           WITH RECURSIVE
              --поиск офиса
              rec_p (id, Name, ParentId, Type) AS (
              SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM staff WHERE staff."Name" = (
                  WITH RECURSIVE
                  --поиск сотрудников
                  rec_c (id, Name, ParentId, Type) AS (
                      SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM staff WHERE id = %s
                      UNION ALL
                      SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM rec_c, staff WHERE 
                      staff.id = rec_c.ParentId
                      )
                  SELECT Name FROM rec_c
                  ORDER BY Type asc LIMIT 1
                  )
              UNION ALL
              SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM rec_p, staff where 
              staff."ParentId" = rec_p.id
              )
       SELECT string_agg(Name, ' ') FROM rec_p where Type != 2
       )
       ELSE 'Сотрудника с данным id не существует. Проверьте правильность ввода'
       END;""", (number, number, number))
        record = list(cur.fetchone())
        result = ''
        result = ''.join(record)
        print(result)

finally:
    if (connection):
        cur.close()
        connection.close()

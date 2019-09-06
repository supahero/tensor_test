
=================!!final!!====================
SELECT
  --проверка, что на входе type сотрудника
  CASE WHEN (SELECT staff."Type" from staff where id = 3) != 3 THEN 'Данный id не принадлежит сотруднику. Проверьте правильность ввода'
       WHEN (SELECT staff."Type" from staff where id = 3) = 3 THEN (
           WITH RECURSIVE
              --поиск офиса
              rec_p (id, Name, ParentId, Type) AS (
              SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM staff WHERE staff."Name" = (
                  WITH RECURSIVE
                  --поиск сотрудников
                  rec_c (id, Name, ParentId, Type) AS (
                      SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM staff WHERE id = 3
                      UNION ALL
                      SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM rec_c, staff WHERE staff.id = rec_c.ParentId
                      )
                  SELECT Name FROM rec_c
                  ORDER BY Type asc LIMIT 1
                  )
              UNION ALL
              SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM rec_p, staff where staff."ParentId" = rec_p.id
              )
       SELECT string_agg(Name, ' ') FROM rec_p where Type != 2
       )
       ELSE 'Сотрудника с данным id не существует. Проверьте правильность ввода'
END;


=============recur============================

WITH RECURSIVE
    -- поиск офиса
    rec_d (id, Name, ParentId, Type) AS
    (
    SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM staff WHERE staff."Name" = (
        WITH RECURSIVE
            --  поиск сотрудников
            rec_a (id, Name, ParentId, Type) AS
            (
              SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM staff WHERE id = 3
              UNION ALL
              SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM rec_a, staff WHERE staff.id = rec_a.ParentId
            )
        SELECT Name FROM rec_a
        ORDER BY Type asc LIMIT 1
        )
    UNION ALL
    SELECT staff.id, staff."Name", staff."ParentId", staff."Type" FROM rec_d, staff where staff."ParentId" = rec_d.id
    )
SELECT string_agg(Name, ', ') FROM rec_d where Type != 2;






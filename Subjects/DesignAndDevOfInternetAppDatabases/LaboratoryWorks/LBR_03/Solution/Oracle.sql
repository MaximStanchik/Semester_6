-- 1. Для базы данных в СУБД SQL Server добавить для одной из таблиц столбец данных иерархического типа. 

SELECT * FROM CLIENT;
DELETE FROM CLIENT;
ALTER TABLE CLIENT ADD PARENT_ID number(4);
ALTER TABLE CLIENT ADD CONSTRAINT fk_parent FOREIGN KEY (PARENT_ID) REFERENCES CLIENT(ID);

INSERT INTO CLIENT (LOGIN, PASSWORD, PARENT_ID)
VALUES ('parent_user', 'parent_password', NULL);

INSERT INTO CLIENT (LOGIN, PASSWORD, PARENT_ID)
VALUES ('child_user', 'child_password', (SELECT ID FROM CLIENT WHERE LOGIN = 'parent_user'));

-- 2. Создать процедуру, которая отобразит все подчиненные узлы с указанием уровня иерархии (параметр – значение узла).
CREATE OR REPLACE PROCEDURE show_subclients(p_parent_id NUMBER) IS
    CURSOR c IS
        SELECT id, login, LEVEL
        FROM client
        START WITH id = p_parent_id
        CONNECT BY PRIOR id = parent_id;
BEGIN
    FOR r IN c LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(' ', (r.level - 1) * 4) || 
                            r.login || ' (ID: ' || r.id || ', уровень ' || r.level || ')');
    END LOOP;
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'SHOW_SUBCLIENTS';

SELECT * 
FROM user_errors 
WHERE name = 'SHOW_SUBCLIENTS' AND type = 'PROCEDURE';

BEGIN
show_subclients(2);
END;

-- 3. Создать процедуру, которая добавит подчиненный узел (параметр – значение родительского узла).
CREATE OR REPLACE PROCEDURE add_subclient(
    p_parent_id NUMBER, 
    p_login VARCHAR2, 
    p_password VARCHAR2
) IS
    v_new_id NUMBER;
BEGIN
    INSERT INTO client (login, password, parent_id)
    VALUES (p_login, p_password, p_parent_id)
    RETURNING id INTO v_new_id;
    
    DBMS_OUTPUT.PUT_LINE('Добавлен клиент с ID: ' || v_new_id);
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'ADD_SUBCLIENT';

SELECT * 
FROM user_errors 
WHERE name = 'ADD_SUBCLIENT' AND type = 'PROCEDURE';

BEGIN
ADD_SUBCLIENT(1, 'child_client', 'secure_password');
END;

SELECT * FROM client;

-- 4.  Создать процедуру, которая переместит всех подчиненных (первый параметр – значение родительского узла, 
-- подчиненные которого будут перемещаться, второй параметр – значение нового родительского узла).
CREATE OR REPLACE PROCEDURE move_subclients(
    p_old_parent_id NUMBER, 
    p_new_parent_id NUMBER
) IS
    v_count NUMBER;
BEGIN
	IF  p_old_parent_id <= 0 OR p_old_parent_id != TRUNC(p_old_parent_id) THEN
	dbms_output.put_line('Number of p_old_parent_id must be a positive integer');
	ELSIF p_new_parent_id <= 0 OR p_new_parent_id != TRUNC(p_old_parent_id) THEN
	dbms_output.put_line('Number of p_new_parent_id must be a positive integer');
	else
    UPDATE client
    SET parent_id = p_new_parent_id
    WHERE parent_id = p_old_parent_id;
    
    v_count := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Перемещено подчиненных клиентов: ' || v_count);
   END IF;
	EXCEPTION 
	WHEN OTHERS THEN 
	dbms_output.put_line('An error occured: ' || sqlerrm);
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'MOVE_SUBCLIENTS';

SELECT * 
FROM user_errors 
WHERE name = '' AND type = 'PROCEDURE';

BEGIN
move_subclients(7, 8);
END;

SELECT * FROM client;
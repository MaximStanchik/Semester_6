-- 2.	Продемонстрировать обработку данных из объектных таблиц при помощи коллекций следующим образом по варианту (в каждом варианте первая таблица t1, вторая – t2):
-- a.	Создать коллекцию на основе t1, далее K1, для нее как атрибут – вложенную коллекцию на основе t2, далее К2;

CREATE OR REPLACE TYPE ClientList AS TABLE OF Client_typeObj;
CREATE OR REPLACE TYPE ClientInfoList AS TABLE OF ClientInfo_typeObj;
CREATE OR REPLACE TYPE ClientInfoLisTt AS TABLE OF ClientInfo_typeObj;

-- 3. Заполняем коллекцию К1 с вложенной коллекцией К2
DECLARE
    K1 ClientList := ClientList();
    K2 ClientInfoList;
BEGIN
    K1.EXTEND; K1(1) := Client_typeObj(1, 'ivanov', 'pass123', NULL);
    K1.EXTEND; K1(2) := Client_typeObj(2, 'petrov', 'pass456', NULL);

    K2 := ClientInfoList();
    K2.EXTEND; K2(1) := ClientInfo_typeObj(1, 1, 'Иван', 'Иванов', 'Иванович', 'Улица Ленина', 'ivanov@example.com', '89001234567');
    
    DBMS_OUTPUT.PUT_LINE('Клиент: ' || K1(1).login);
    DBMS_OUTPUT.PUT_LINE('Информация о клиенте: ' || K2(1).first_name);
END;

-- b.	Выяснить, является ли членом коллекции К1 какой-то произвольный элемент;
DECLARE
    TYPE ClientList IS TABLE OF Client_typeObj;
    K1 ClientList := ClientList();  
    client_found BOOLEAN := FALSE;
    search_login NVARCHAR2(255) := 'ivanov';
BEGIN
    K1.EXTEND; K1(1) := Client_typeObj(1, 'ivanov', 'pass123', NULL);
    K1.EXTEND; K1(2) := Client_typeObj(2, 'petrov', 'pass456', NULL);

    FOR i IN 1 .. K1.COUNT LOOP
        IF K1(i).login = search_login THEN
            client_found := TRUE;
            EXIT;
        END IF;
    END LOOP;

    IF client_found THEN
        DBMS_OUTPUT.PUT_LINE('Клиент ' || search_login || ' найден в коллекции K1.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Клиент ' || search_login || ' не найден в коллекции K1.');
    END IF;
END;

-- c.	Найти пустые коллекции К1; ---!

DECLARE
    TYPE ClientList IS TABLE OF Client_typeObj;
    TYPE ClientInfoList IS TABLE OF ClientInfo_typeObj;

    K1 ClientList := ClientList();
    K2 ClientInfoList;  
    K3 ClientList := ClientList();  

    empty_collections INTEGER := 0;
BEGIN
    K1.EXTEND; K1(1) := Client_typeObj(1, 'ivanov', 'pass123', NULL);
    K1.EXTEND; K1(2) := Client_typeObj(2, 'petrov', 'pass456', NULL);

    -- Проверка K1
    IF K1 IS NULL OR K1.COUNT = 0 THEN
        empty_collections := empty_collections + 1;
        DBMS_OUTPUT.PUT_LINE('Коллекция K1 пуста.');
    END IF;

    -- Проверка K2
    IF K2 IS NULL OR K2.COUNT = 0 THEN
        empty_collections := empty_collections + 1;
        DBMS_OUTPUT.PUT_LINE('Коллекция K2 пуста.');
    END IF;

    -- Проверка K3
    IF K3 IS NULL OR K3.COUNT = 0 THEN
        empty_collections := empty_collections + 1;
        DBMS_OUTPUT.PUT_LINE('Коллекция K3 пуста.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Всего пустых коллекций: ' || empty_collections);
END;

-- 3.	Преобразовать коллекцию к другому виду (к коллекции другого типа, к реляционным данным).
DECLARE
    TYPE ClientList IS TABLE OF Client_typeObj;
    TYPE ClientInfoList IS TABLE OF ClientInfo_typeObj;
    
    K1 ClientList := ClientList(); 
    K1_Converted ClientInfoList;     
    
BEGIN
    K1.EXTEND; K1(1) := Client_typeObj(1, 'ivanov', 'pass123', NULL);
    K1.EXTEND; K1(2) := Client_typeObj(2, 'petrov', 'pass456', NULL);
   
    K1_Converted := ClientInfoList();
    
    FOR i IN 1 .. K1.COUNT LOOP
        K1_Converted.EXTEND;
        K1_Converted(i) := ClientInfo_typeObj(i, K1(i).id, 'Имя_' || i, 'Фамилия_' || i, 'Отчество_' || i, 'Адрес_' || i, 'email@example.com', '89001234567');
    END LOOP;

    FOR i IN 1 .. K1_Converted.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Клиент: ' || K1_Converted(i).first_name || ' ' || K1_Converted(i).last_name);
    END LOOP;
END;

-- 4.	Продемонстрировать применение BULK операций на примере своих коллекций.

DECLARE
    TYPE ClientList IS TABLE OF Client_typeObj;
    K1 ClientList := ClientList();
BEGIN
    K1.EXTEND(3);
    K1(1) := Client_typeObj(1, 'ivanov', 'pass123', NULL);
    K1(2) := Client_typeObj(2, 'petrov', 'pass456', NULL);
    K1(3) := Client_typeObj(3, 'sidorov', 'pass789', NULL);

    FORALL i IN 1 .. K1.COUNT
        INSERT INTO ClientObj VALUES (K1(i));
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Добавлено ' || K1.COUNT || ' клиентов в таблицу ClientObj.');
END;
-- ограниченные и неограниченные + 
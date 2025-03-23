-- Функция для подсчета количества доставленных заказов
CREATE OR REPLACE FUNCTION COUNT_DELIVERED_ORDERS(startDate IN TIMESTAMP, endDate IN TIMESTAMP) RETURN NUMBER IS
    delivered_count NUMBER;
BEGIN
	IF startDate > endDate THEN
	dbms_output.put_line('Start date is higher then end date');
	RETURN 0;
	elsif startDate IS NULL OR endDate IS NULL THEN 
	dbms_output.put_line('Start date or end date is null');
	RETURN 0;
	ELSIF startDate < to_date('2000-01-01', 'YYYY-MM-DD') OR endDate < to_date('2000-01-01', 'YYYY-MM-DD') THEN 
	dbms_output.put_line('Date can not be earlier then "2000-01-01"');
	RETURN 0;
	ELSE 
    SELECT COUNT(*) INTO delivered_count
    FROM ORDERS
    WHERE STATUS = 'Delivered' AND DELIVERED_AT BETWEEN startDate AND endDate;
    RETURN delivered_count;
   	END IF;
END COUNT_DELIVERED_ORDERS;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION' AND OBJECT_NAME = 'COUNT_DELIVERED_ORDERS';

SELECT * 
FROM user_errors 
WHERE name = 'COUNT_DELIVERED_ORDERS' AND type = 'FUNCTION';

DECLARE
    delivered_orders_count NUMBER;
BEGIN
    -- Пример 1: Нормальный случай
    delivered_orders_count := COUNT_DELIVERED_ORDERS(TIMESTAMP '2023-01-01 00:00:00', TIMESTAMP '2023-12-31 23:59:59');
    DBMS_OUTPUT.PUT_LINE('Delivered Orders Count (2023): ' || delivered_orders_count);

    -- Пример 2: Начальная дата больше конечной
    delivered_orders_count := COUNT_DELIVERED_ORDERS(TIMESTAMP '2023-12-31 23:59:59', TIMESTAMP '2023-01-01 00:00:00');
    DBMS_OUTPUT.PUT_LINE('Delivered Orders Count (Invalid Date Range): ' || delivered_orders_count);

    -- Пример 3: Одна из дат NULL
    delivered_orders_count := COUNT_DELIVERED_ORDERS(NULL, TIMESTAMP '2023-12-31 23:59:59');
    DBMS_OUTPUT.PUT_LINE('Delivered Orders Count (NULL Start Date): ' || delivered_orders_count);

    -- Пример 4: Дата раньше 2000-01-01
    delivered_orders_count := COUNT_DELIVERED_ORDERS(TIMESTAMP '1999-12-31 23:59:59', TIMESTAMP '2023-12-31 23:59:59');
    DBMS_OUTPUT.PUT_LINE('Delivered Orders Count (Before 2000): ' || delivered_orders_count);
    
    -- Пример 5: Пустой диапазон
    delivered_orders_count := COUNT_DELIVERED_ORDERS(TIMESTAMP '2023-01-01 00:00:00', TIMESTAMP '2023-01-01 00:00:00');
    DBMS_OUTPUT.PUT_LINE('Delivered Orders Count (Same Date): ' || delivered_orders_count);
END;

-- Функция для получения информации о водителе по ID
CREATE OR REPLACE FUNCTION GET_DRIVER_INFO(driver_id IN NUMBER) RETURN VARCHAR2 IS
    driver_info VARCHAR2(255);
BEGIN
    IF driver_id <= 0 THEN
        dbms_output.put_line('Number of driver must be a positive integer');
        RETURN '0';
    END IF;

    DECLARE
        driver_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO driver_count
        FROM DRIVER_INFO
        WHERE DRIVER_ID = driver_id;
       
        IF driver_count = 0 THEN
            RETURN '0';
        END IF;

        SELECT 'Name: ' || FIRST_NAME || ' ' || LAST_NAME || ', Phone: ' || PHONE_NUMBER
        INTO driver_info
        FROM DRIVER_INFO
        WHERE DRIVER_ID = driver_id
        AND ROWNUM = 1;  

        RETURN driver_info;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '0'; 
    END;
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        RETURN 'Error: More than one driver found.';  
END GET_DRIVER_INFO;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION' AND OBJECT_NAME = 'GET_DRIVER_INFO';

SELECT * 
FROM user_errors 
WHERE name = 'GET_DRIVER_INFO' AND type = 'FUNCTION';
 
DECLARE
    driver_info VARCHAR2(255);
BEGIN
    -- Пример 1: Существующий водитель
    driver_info := GET_DRIVER_INFO(1);
    DBMS_OUTPUT.PUT_LINE('Driver Info (ID 1): ' || driver_info);

    -- Пример 2: Не существующий водитель
    driver_info := GET_DRIVER_INFO(9999);
    DBMS_OUTPUT.PUT_LINE('Driver Info (ID 9999): ' || driver_info);

    -- Пример 3: Неверный ID
    driver_info := GET_DRIVER_INFO(-1);
    DBMS_OUTPUT.PUT_LINE('Driver Info (ID -1): ' || driver_info);
END;

-- Функция для получения общего кол-ва грузов
CREATE OR REPLACE FUNCTION GetTotalCargo
RETURN NUMBER AS
    v_TotalCargo NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_TotalCargo FROM CARGO;
    RETURN v_TotalCargo;
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION' AND OBJECT_NAME = 'GETTOTALCARGO';

SELECT * 
FROM user_errors 
WHERE name = 'GETTOTALCARGO' AND type = 'FUNCTION';

SELECT GetTotalCargo() AS TotalCargo FROM DUAL;

-- Функция для получения общего количества заказов за определенный период
CREATE OR REPLACE FUNCTION GetTotalOrdersByDate(
    p_StartDate IN DATE,
    p_EndDate IN DATE
) RETURN NUMBER AS
    v_TotalOrders NUMBER;
BEGIN
    IF p_StartDate IS NULL OR p_EndDate IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Start date or end date is null');
        RETURN 0;
    ELSIF p_StartDate > p_EndDate THEN
        DBMS_OUTPUT.PUT_LINE('Start date is later than end date');
        RETURN 0;
    ELSE
        SELECT COUNT(*) INTO v_TotalOrders
        FROM ORDERS
        WHERE CREATED_AT BETWEEN p_StartDate AND p_EndDate;

        RETURN v_TotalOrders;
    END IF;
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION' AND OBJECT_NAME = 'GETTOTALORDERSBYDATE';

SELECT * 
FROM user_errors 
WHERE name = 'GETTOTALORDERSBYDATE' AND type = 'FUNCTION';

SELECT GetTotalOrdersByDate(
    TO_DATE('2025-03-15', 'YYYY-MM-DD'), 
    TO_DATE('2025-03-20', 'YYYY-MM-DD')
) AS TotalOrders
FROM DUAL;

-- Функция для получения количества активных водителей
CREATE OR REPLACE FUNCTION GetActiveDriversCount RETURN NUMBER IS
    v_ActiveDriversCount NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_ActiveDriversCount 
    FROM DRIVER D
    JOIN DRIVER_INFO DI ON D.ID = DI.DRIVER_ID
    WHERE EXISTS (SELECT 1 FROM VEHICLE V WHERE V.DRIVER_ID = D.ID AND V.STATUS = 'Available');
    
    RETURN v_ActiveDriversCount;
END GetActiveDriversCount;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION' AND OBJECT_NAME = 'GETACTIVEDRIVERSCOUNT';

SELECT * 
FROM user_errors 
WHERE name = 'GETACTIVEDRIVERSCOUNT' AND type = 'FUNCTION';

DECLARE
    v_Count NUMBER;
BEGIN
    v_Count := GetActiveDriversCount;
    DBMS_OUTPUT.PUT_LINE('Active Drivers Count: ' || v_Count);
END;

-- 2.	Создать объектные типы данных по своему варианту, реализовав:

-- Объектные типы для клиентов

CREATE OR REPLACE TYPE Client_typeObj AS OBJECT (
    id NUMBER,
    login NVARCHAR2(255),
    password NVARCHAR2(255),
    parent_id NUMBER(4)  
);

-- + Процедура как метод экземпляра
CREATE OR REPLACE TYPE ClientInfo_typeObj AS OBJECT (
    id NUMBER,
    client_id NUMBER,
    first_name NVARCHAR2(50),
    last_name NVARCHAR2(50),
    middle_name NVARCHAR2(50),
    address NVARCHAR2(255),
    email NVARCHAR2(100),
    phone_number NVARCHAR2(50),
    
    MEMBER PROCEDURE update_address(new_address IN NVARCHAR2)
);

CREATE OR REPLACE TYPE BODY ClientInfo_typeObj AS
    MEMBER PROCEDURE update_address(new_address IN NVARCHAR2) IS
    BEGIN
        self.address := new_address;
    END;
END;

SELECT * FROM user_errors WHERE name = 'update_address' AND TYPE = 'PROCEDURE';

-- Объектный тип для водителей
CREATE OR REPLACE TYPE Driver_typeObj AS OBJECT (
    id NUMBER,
    login NVARCHAR2(255),
    password NVARCHAR2(255)
);

-- Объектный тип для дополнительной информации о водителях + реализация функции как метода экземпляра
CREATE OR REPLACE TYPE DriverInfo_typeObj AS OBJECT ( 
    id NUMBER,
    driver_id NUMBER,
    first_name NVARCHAR2(50),
    last_name NVARCHAR2(50),
    middle_name NVARCHAR2(50),
    address NVARCHAR2(255),
    birth_date DATE,
    email NVARCHAR2(100),
    passport_num NVARCHAR2(50),
    phone_number NVARCHAR2(50),
    vehicle_info NUMBER,
    MEMBER FUNCTION full_name RETURN NVARCHAR2
);

CREATE OR REPLACE TYPE BODY DriverInfo_typeObj AS
    MEMBER FUNCTION full_name RETURN NVARCHAR2 IS
    BEGIN
        RETURN TRIM(last_name || ' ' || first_name || ' ' || middle_name);
    END;
END;


SELECT * FROM user_errors WHERE name = 'DriverInfo_typeObj' AND TYPE = 'PROCEDURE';

-- Объектный тип для грузов + функция как метод экземпляра 
CREATE OR REPLACE TYPE Cargo_typeObj AS OBJECT (
    id NUMBER,
    name NVARCHAR2(50),
    description NVARCHAR2(255),
    weight NUMBER(10, 2),
    volume NUMBER(10, 2),
    cargo_type NUMBER,
    hazardous NVARCHAR2(7),
    
    MEMBER FUNCTION compare(other IN Cargo_typeObj) RETURN NUMBER
) NOT FINAL;

CREATE OR REPLACE TYPE BODY Cargo_typeObj AS
    ORDER MEMBER FUNCTION compare_to(other IN Cargo_typeObj) RETURN INTEGER IS
    BEGIN
        IF name < other.name THEN
            RETURN -1;
        ELSIF name > other.name THEN
            RETURN 1;
        ELSE
            IF weight < other.weight THEN
                RETURN -1;
            ELSIF weight > other.weight THEN
                RETURN 1;
            ELSE
                RETURN 0;
            END IF;
        END IF;
    END;
END;

SELECT * FROM user_errors WHERE name = 'Cargo_typeObj';

-- Объектный тип для типов грузов
CREATE OR REPLACE TYPE CargoType_typeObj AS OBJECT (
    id NUMBER,
    name NVARCHAR2(255),
    description NVARCHAR2(255)
);

-- Объектный тип для заказов
CREATE OR REPLACE TYPE Orders_typeObj AS OBJECT (
    id NUMBER,
    client_id NUMBER,
    driver_id NUMBER,
    service_id NUMBER,
    status NVARCHAR2(50),
    created_at TIMESTAMP,
    route NUMBER,
    delivery_type NVARCHAR2(50),
    total_weight NUMBER(10, 2),
    total_volume NUMBER(10, 2),
    delivered_at TIMESTAMP,
    fuel_consumption NUMBER(10, 2),  
    fuel_cost NUMBER(10, 2)           
);

-- Объектный тип для транспортных средств
CREATE OR REPLACE TYPE Vehicle_typeObj AS OBJECT (
    id NUMBER,
    driver_id NUMBER,
    vehicle_type NUMBER,
    license_plate NVARCHAR2(20),
    model NVARCHAR2(50),
    capacity NUMBER(10, 2),
    insurance_expiry DATE,
    status NVARCHAR2(20)
);

-- Объектный тип для типов транспортных средств
CREATE OR REPLACE TYPE VehicleType_typeObj AS OBJECT (
    id NUMBER,
    name NVARCHAR2(255),
    description NVARCHAR2(255)
);

-- Объектный тип для типов услуг + реализация конструктора
CREATE OR REPLACE TYPE ServiceType_typeObj AS OBJECT ( 
    id NUMBER,
    name NVARCHAR2(255),
    description NVARCHAR2(255),
    MEMBER FUNCTION get_description RETURN NVARCHAR2 DETERMINISTIC
);

CREATE OR REPLACE TYPE BODY ServiceType_typeObj AS
    MEMBER FUNCTION get_description RETURN NVARCHAR2 DETERMINISTIC IS
    BEGIN
        RETURN self.description;  
    END;
END;

-- Объектный тип для маршрутов
CREATE OR REPLACE TYPE Routes_typeObj AS OBJECT (
    id NUMBER,
    start_location NVARCHAR2(255),
    end_location NVARCHAR2(255),
    distance NUMBER(10, 2)
);

-- Объектный тип для стоимости топлива
CREATE OR REPLACE TYPE FuelCosts_typeObj AS OBJECT (
    id NUMBER,
    month NUMBER,
    year NUMBER,
    price_per_liter NUMBER(10, 2)
);

-- Объектный тип для сервисов
CREATE OR REPLACE TYPE Service_typeObj AS OBJECT (
    id NUMBER,
    name NVARCHAR2(255),
    description NVARCHAR2(255),
    base_rate NUMBER(10, 2),
    service_type_id NUMBER(4),
    created_at TIMESTAMP,
    FUEL_COST_FACTOR NUMBER(10, 2)
);

-- 3.	Скопировать данные из реляционных таблиц в объектные:
CREATE TABLE RoutesObj OF Routes_typeObj;
CREATE TABLE ServicesObj OF Service_typeObj;
CREATE TABLE ServiceTypeObj OF ServiceType_typeObj;
CREATE TABLE VehicleTypeObj OF VehicleType_typeObj;
CREATE TABLE VehicleObj OF Vehicle_typeObj;
CREATE TABLE CargoTypeObj OF CargoType_typeObj;
CREATE TABLE CargoObj OF Cargo_typeObj;
CREATE TABLE DriverInfoObj OF DriverInfo_typeObj;
CREATE TABLE DriverObj OF Driver_typeObj;
CREATE TABLE ClientInfoObj OF ClientInfo_typeObj; 
CREATE TABLE ClientObj OF Client_typeObj;
CREATE TABLE OrdersObj OF Orders_typeObj;
CREATE TABLE FuelCostsObj OF FuelCosts_typeObj;

drop TABLE VehicleTypeObj;
DROP TABLE ServicesObj;
drop TABLE VehicleObj;
drop TABLE CargoTypeObj;
drop TABLE CargoObj;
drop TABLE DriverInfoObj;
drop TABLE DriverObj;
drop TABLE ClientInfoObj;
drop TABLE ClientObj;
drop TABLE OrdersObj;
drop TABLE FuelCostsObj;
DROP TABLE ServiceTypeObj;

INSERT INTO RoutesObj SELECT * FROM ROUTES; 
SELECT * FROM RoutesObj;

INSERT INTO ServicesObj SELECT * FROM SERVICES;
SELECT * FROM ServicesObj;

INSERT INTO ServiceTypeObj SELECT * FROM SERVICE_TYPE;
SELECT * FROM ServiceTypeObj; 

INSERT INTO VehicleTypeObj SELECT * FROM VEHICLE_TYPE;
SELECT * FROM VehicleTypeObj;

INSERT INTO VehicleObj SELECT * FROM VEHICLE;
SELECT * FROM VehicleObj;

INSERT INTO CargoTypeObj SELECT * FROM CARGO_TYPE;
SELECT * FROM CargoTypeObj;

INSERT INTO CargoObj SELECT * FROM CARGO;
SELECT * FROM CargoObj;

INSERT INTO DriverInfoObj SELECT * FROM DRIVER_INFO;
SELECT * FROM DriverInfoObj;

INSERT INTO DriverObj SELECT * FROM DRIVER;
SELECT * FROM DriverObj;

INSERT INTO ClientInfoObj SELECT * FROM CLIENT_INFO;
SELECT * FROM ClientInfoObj;

INSERT INTO ClientObj SELECT * FROM CLIENT; 
SELECT * FROM ClientObj; 

INSERT INTO OrdersObj SELECT * FROM ORDERS; 
SELECT * FROM OrdersObj; 

INSERT INTO FuelCostsObj SELECT * FROM FUEL_COSTS;
SELECT * FROM FuelCostsObj;

-- 4.	Продемонстрировать применение объектных представлений:

-- Использование конструктора: 
DECLARE
    serviceObj ServiceType_typeObj;
    serviceName NVARCHAR2(255);
    serviceDescription NVARCHAR2(255);
    new_id NUMBER;
BEGIN
    SELECT NVL(MAX(id), 0) + 1 INTO new_id FROM ServiceTypeObj;
    
    serviceObj := ServiceType_typeObj(new_id, 'Доставка', 'Доставка товаров');
    
    INSERT INTO ServiceTypeObj VALUES (serviceObj);
    COMMIT;

    SELECT name, description INTO serviceName, serviceDescription
    FROM ServiceTypeObj
    WHERE id = new_id; 

    DBMS_OUTPUT.PUT_LINE('Услуга: ' || serviceName || ', Описание: ' || serviceDescription);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Услуга не найдена');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Найдено несколько услуг с одинаковым ID');
END;
SELECT * FROM clientInfoObj;
-- Использование методов экземпляра: 
DECLARE
    clientInfoObj ClientInfo_typeObj := ClientInfo_typeObj(1, 1, 'Иван', 'Иванов', 'Иванович', 'Улица Ленина, дом 1', 'ivanov@example.com', '89001234567');
BEGIN
    DBMS_OUTPUT.PUT_LINE('Старый адрес: ' || clientInfoObj.address);
    clientInfoObj.update_address('Улица Нова, дом 10');
    
    DBMS_OUTPUT.PUT_LINE('Новый адрес: ' || clientInfoObj.address);
END;

-- Использование функции экземпляра:
DECLARE
    driverInfoObj DriverInfo_typeObj := DriverInfo_typeObj(1, 1, 'Петр', 'Петров', 'Петрович', 'Улица Пушкина, дом 1', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 'petrov@example.com', '1234567890', '89001234567', NULL);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Полное имя водителя: ' || driverInfoObj.full_name());
END;

-- Использование функции сравнения для грузов: 
DECLARE
    cargo1 Cargo_typeObj := Cargo_typeObj(1, 'Груз A', 'Описание A', 10.5, 5.0, 1, 'Нет');
    cargo2 Cargo_typeObj := Cargo_typeObj(2, 'Груз B', 'Описание B', 20.0, 10.0, 2, 'Да');
    comparisonResult NUMBER;
BEGIN
    comparisonResult := cargo1.compare(cargo2);
    
    IF comparisonResult = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Грузы одинаковы.');
    ELSIF comparisonResult < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Груз A меньше Груза B.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Груз A больше Груза B.');
    END IF;
END;

-- Использование вставок:
BEGIN
    INSERT INTO ClientObj VALUES (Client_typeObj(2, 'ivanov_', 'password124', NULL));
    INSERT INTO ServicesObj VALUES (Service_typeObj(2, 'Доставка', 'Доставка заказов', 150.00, 1, SYSTIMESTAMP, 1.0));
    INSERT INTO DriverObj VALUES (Driver_typeObj(2, 'petrovv', 'password457'));
   	commit;
END;

SELECT * FROM ClientObj;
SELECT * FROM ServicesObj;
SELECT * FROM DriverObj;

-- 5.	Продемонстрировать применение индексов для индексирования по атрибуту и по методу в объектной таблице:
-- по атрибуту:
CREATE INDEX idx_service_name ON ServiceTypeObj(name);

-- по методу:
create table ServiceType_typeObj_INDEX(
    ServiceType_typeObj ServiceType_typeObj
);
DROP TABLE ServiceType_typeObj_INDEX;
select * from ServiceType_typeObj_INDEX;

BEGIN
  FOR i IN 1..10000 LOOP
    INSERT INTO ServiceType_typeObj_INDEX(ServiceType_typeObj)
    VALUES(ServiceType_typeObj(i, 'Service_'||i, 'Description_'||i));
  END LOOP;
  COMMIT;
END;

DECLARE
  v_start_id NUMBER;
  v_batch_size NUMBER := 1000; 
BEGIN
  SELECT NVL(MAX(id), 0) INTO v_start_id FROM ServiceTypeObj;
  
  FOR i IN 1..10 LOOP 
    INSERT INTO ServiceTypeObj
    SELECT 
      ServiceType_typeObj(
        v_start_id + (i-1)*v_batch_size + LEVEL,
        'Service_' || (v_start_id + (i-1)*v_batch_size + LEVEL),
        'Description for service ' || (v_start_id + (i-1)*v_batch_size + LEVEL)
      )
    FROM dual
    CONNECT BY LEVEL <= v_batch_size;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Добавлено ' || i*v_batch_size || ' записей');
  END LOOP;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Всего добавлено 10000 записей');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
    ROLLBACK;
END;

create index idx_service_description on ServiceType_typeObj_INDEX (ServiceType_typeObj.get_description());

-- проверка созданнных индексов:
SELECT index_name, index_type, uniqueness, table_name FROM user_indexes WHERE table_name = 'SERVICETYPEOBJ';
SELECT index_name, index_type, uniqueness, table_name FROM user_indexes WHERE table_name = 'SERVICETYPE_TYPEOBJ_INDEX';
SELECT * FROM SERVICETYPEOBJ;

-- проверка использования индекса по атрибуту:
SELECT * FROM ServiceTypeObj;
SELECT * FROM ServiceTypeObj s WHERE s.name BETWEEN 'Service_40000' AND 'Service_60000' ORDER BY s.name;
SELECT sql_id, sql_text FROM v$sql WHERE sql_text LIKE '%INDEX(s idx_service_name)%';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('cnu2kdtch3k7n', 0, 'ALLSTATS LAST'));

-- проверка использования индекса по методу:
SELECT * FROM ServiceType_typeObj_INDEX;
SELECT * FROM ServiceType_typeObj_INDEX s WHERE s.ServiceType_typeObj.get_description() LIKE 'Description_5%';
SELECT sql_id, sql_text FROM v$sql WHERE sql_text LIKE '%INDEX(s idx_service_name)%';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('cnu2kdtch3k7n', 0, 'ALLSTATS LAST'));
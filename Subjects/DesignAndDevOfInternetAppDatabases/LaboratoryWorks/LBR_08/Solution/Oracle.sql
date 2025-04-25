-- 2.	Создать объектные типы данных по своему варианту, реализовав:

CREATE OR REPLACE TYPE Client_typeObj AS OBJECT (
    id NUMBER,
    login NVARCHAR2(255),
    password NVARCHAR2(255),
    parent_id NUMBER(4)  
);

CREATE OR REPLACE TYPE ClientInfo_typeObj AS OBJECT (
    id NUMBER,
    client_id NUMBER,
    first_name NVARCHAR2(50),
    last_name NVARCHAR2(50),
    middle_name NVARCHAR2(50),
    address NVARCHAR2(255),
    email NVARCHAR2(100),
    phone_number NVARCHAR2(50)
);

-- Объектный тип для водителей
CREATE OR REPLACE TYPE Driver_typeObj AS OBJECT (
    id NUMBER,
    login NVARCHAR2(255),
    password NVARCHAR2(255)
);

-- Объектный тип для дополнительной информации о водителях
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
    vehicle_info NUMBER
);

-- Объектный тип для грузов
CREATE OR REPLACE TYPE Cargo_typeObj AS OBJECT (
    id NUMBER,
    name NVARCHAR2(50),
    description NVARCHAR2(255),
    weight NUMBER(10, 2),
    volume NUMBER(10, 2),
    cargo_type NUMBER,
    hazardous NVARCHAR2(7)
);

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

-- Объектный тип для типов услуг
CREATE OR REPLACE TYPE ServiceType_typeObj AS OBJECT (
    id NUMBER,
    name NVARCHAR2(255),
    description NVARCHAR2(255),
    CONSTRUCTOR FUNCTION ServiceType_typeObj(p_name NVARCHAR2, p_description NVARCHAR2) IS
    BEGIN
        self.name := p_name;
        self.description := p_description;
        self.id := NULL;  
    END
);

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

-- Объектный тип для услуг с дополнительным полем
CREATE OR REPLACE TYPE BODY ServiceType_typeObj AS
    MEMBER FUNCTION full_info RETURN NVARCHAR2 IS
    BEGIN
        RETURN 'ID: ' || self.id || ', Name: ' || self.name || ', Description: ' || self.description;
    END;

    MEMBER PROCEDURE update_description(new_description IN NVARCHAR2) IS
    BEGIN
        self.description := new_description;
    END;
END;
-- 3.	Скопировать данные из реляционных таблиц в объектные.
CREATE TABLE RoutesObj OF Routes_typeObj;
CREATE TABLE ServicesObj OF Services_typeObj; ----!
CREATE TABLE ServiceTypeObj OF ServiceType_typeObj;

DECLARE
    serviceType ServiceType_typeObj;
BEGIN
    serviceType := ServiceType_typeObj('Delivery', 'Delivery of goods');
    DBMS_OUTPUT.PUT_LINE(serviceType.full_info);
    serviceType.update_description('Updated description for delivery.');
    DBMS_OUTPUT.PUT_LINE('Updated Info: ' || serviceType.full_info);
END;

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

INSERT INTO RoutesObj SELECT * FROM ROUTES; 
SELECT * FROM RoutesObj;

INSERT INTO ServicesObj SELECT * FROM SERVICES;

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

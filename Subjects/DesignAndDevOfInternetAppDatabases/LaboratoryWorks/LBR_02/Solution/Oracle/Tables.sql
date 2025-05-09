SELECT * FROM CLIENT;
SELECT * FROM CLIENT_INFO;
SELECT * FROM DRIVER;
SELECT * FROM DRIVER_INFO;
SELECT * FROM CARGO; 
SELECT * FROM CARGO_TYPE; 
SELECT * FROM ORDERS; 
SELECT * FROM VEHICLE;  
SELECT * FROM VEHICLE_TYPE;
SELECT * FROM SERVICE_TYPE;
SELECT * FROM SERVICES; 
SELECT * FROM ROUTES;
SELECT * FROM FUEL_COSTS;


SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'ORDERS';

DROP TABLE ORDERS CASCADE CONSTRAINTS;
DROP TABLE CLIENT_INFO CASCADE CONSTRAINTS;
DROP TABLE DRIVER_INFO CASCADE CONSTRAINTS;
DROP TABLE CARGO CASCADE CONSTRAINTS;
DROP TABLE VEHICLE CASCADE CONSTRAINTS;
DROP TABLE SERVICES CASCADE CONSTRAINTS;
DROP TABLE ROUTES CASCADE CONSTRAINTS;
DROP TABLE VEHICLE_TYPE CASCADE CONSTRAINTS;
DROP TABLE SERVICE_TYPE CASCADE CONSTRAINTS;
DROP TABLE CARGO_TYPE CASCADE CONSTRAINTS;
DROP TABLE CLIENT CASCADE CONSTRAINTS;
DROP TABLE DRIVER CASCADE CONSTRAINTS;

-- Информация о клиентах
CREATE TABLE CLIENT (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    LOGIN nvarchar2(255) not null, 
    PASSWORD nvarchar2(255) not null
);

-- Дополнительная информация о клиентах
CREATE TABLE CLIENT_INFO (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    CLIENT_ID number(4) not null,
    FIRST_NAME nvarchar2(50) not null, 
    LAST_NAME nvarchar2(50) not null, 
    MIDDLE_NAME nvarchar2(50) not null, 
    ADDRESS nvarchar2(255), 
    EMAIL nvarchar2(100),
    PHONE_NUMBER nvarchar2(50), 
    FOREIGN KEY (CLIENT_ID) REFERENCES CLIENT(ID)
);

-- Информация о водителях
CREATE TABLE DRIVER (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    LOGIN nvarchar2(255) not null, 
    PASSWORD nvarchar2(255) not null
);

-- Дополнительная информация о водителях
CREATE TABLE DRIVER_INFO (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    DRIVER_ID number(4) not null,
    FIRST_NAME nvarchar2(50) not null, 
    LAST_NAME nvarchar2(50) not null, 
    MIDDLE_NAME nvarchar2(50) not null, 
    ADDRESS nvarchar2(255), 
    BIRTH_DATE date,
    EMAIL nvarchar2(100),
    PASSPORT_NUM nvarchar2(50) not null, 
    PHONE_NUMBER nvarchar2(50), 
    VEHICLE_INFO number(4) not null,  
    FOREIGN KEY (DRIVER_ID) REFERENCES DRIVER(ID),
    FOREIGN KEY (VEHICLE_INFO) REFERENCES VEHICLE(ID)
);

-- Информация о грузах
CREATE TABLE CARGO (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    NAME nvarchar2(50) not null, 
    DESCRIPTION nvarchar2(255),
    WEIGHT number(10, 2) not null, 
    VOLUME number(10, 2) not null, 
    CARGO_TYPE number(4),  -- Изменено на number(4)
    HAZARDOUS nvarchar2(7) check (HAZARDOUS IN ('No', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9')),
    FOREIGN KEY (CARGO_TYPE) REFERENCES CARGO_TYPE(ID)
);

-- Типы грузов
CREATE TABLE CARGO_TYPE (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    NAME nvarchar2(255) not null, 
    DESCRIPTION nvarchar2(255) not null
);

-- Информация о заказах
CREATE TABLE ORDERS (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    CLIENT_ID number(4) not null,
    DRIVER_ID number(4), 
    SERVICE_ID number(4) not null,
    STATUS nvarchar2(50) check (STATUS IN ('Pending', 'In Transit', 'Delivered', 'Cancellation Requested', 'Cancelled', 'On Hold', 'Returned', 'Lost', 'Awaiting Pickup', 'Out for Delivery', 'Completed', 'Exception', 'Scheduled', 'In Warehouse', 'Awaiting Clearance', 'Delayed')),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ROUTE number(4) not null,
    DELIVERY_TYPE nvarchar2(50) not null,
    TOTAL_WEIGHT number(10, 2),
    TOTAL_VOLUME number(10, 2),
    DELIVERED_AT TIMESTAMP,
    FOREIGN KEY (CLIENT_ID) REFERENCES CLIENT(ID),
    FOREIGN KEY (DRIVER_ID) REFERENCES DRIVER(ID),  
    FOREIGN KEY (SERVICE_ID) REFERENCES SERVICES(ID),
    FOREIGN KEY (ROUTE) REFERENCES ROUTES(ID)
);

-- Информация о транспортных средствах
CREATE TABLE VEHICLE (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    DRIVER_ID number(4),
    VEHICLE_TYPE number(4) not null,  
    LICENSE_PLATE nvarchar2(20) not null,
    MODEL nvarchar2(50) not null, 
    CAPACITY number(10, 2) not null, 
    INSURANCE_EXPIRY DATE not null,
    STATUS nvarchar2(20) check (STATUS IN ('In transit', 'Arrived', 'At stop', 'Delayed', 'Cancelled', 'Under maintenance', 'Available', 'On route', 'Delivered', 'Waiting', 'Issue with cargo', 'Free', 'Busy', 'Searching', 'Completed', 'On platform')),  
    FOREIGN KEY (DRIVER_ID) REFERENCES DRIVER(ID),
    FOREIGN KEY (VEHICLE_TYPE) REFERENCES VEHICLE_TYPE(ID)  
);

-- Типы транспортных средств
CREATE TABLE VEHICLE_TYPE (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    NAME nvarchar2(255) not null,
    DESCRIPTION nvarchar2(255) not null
);
-- Типы услуг
CREATE TABLE SERVICE_TYPE (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    NAME nvarchar2(255) not null,
    DESCRIPTION nvarchar2(255) not null
);

-- Информация об услугах
CREATE TABLE SERVICES (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    NAME nvarchar2(255) not null,
    DESCRIPTION nvarchar2(255) not null,
    BASE_RATE number(10, 2),  
    SERVICE_TYPE_ID number(4),  
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SERVICE_TYPE_ID) REFERENCES SERVICE_TYPE(ID)
);

-- Информация о маршрутах
CREATE TABLE ROUTES (
    ID number(4) generated by default on null as identity PRIMARY KEY,
    START_LOCATION nvarchar2(255) not null,  
    END_LOCATION nvarchar2(255) not null,    
    DISTANCE number(10, 2)            
);
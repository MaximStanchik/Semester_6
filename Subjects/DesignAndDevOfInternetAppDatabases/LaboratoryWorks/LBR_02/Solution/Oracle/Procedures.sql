-- Процедура для получения списка заказов, которые были доставлены с использованием определенного типа транспортного средства:
CREATE OR REPLACE PROCEDURE GET_ORDERS_BY_VEHICLE_TYPE(
    p_VehicleTypeID IN NUMBER  
)
IS
    CURSOR orders_cursor IS
        SELECT O.ID AS ORDER_ID, 
               O.CLIENT_ID, 
               O.DRIVER_ID, 
               O.SERVICE_ID, 
               O.STATUS, 
               O.CREATED_AT, 
               O.DELIVERED_AT, 
               O.TOTAL_WEIGHT, 
               O.TOTAL_VOLUME
        FROM ORDERS O
        JOIN DRIVER D ON O.DRIVER_ID = D.ID
        JOIN DRIVER_INFO DI ON D.ID = DI.DRIVER_ID
        JOIN VEHICLE V ON DI.VEHICLE_INFO = V.ID
        WHERE V.VEHICLE_TYPE = p_VehicleTypeID
          AND O.STATUS = 'Delivered';  

    v_row_count NUMBER := 0; 
BEGIN
    IF p_VehicleTypeID < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Vehicle type ID must be a non-negative number.');
    END IF;

    IF p_VehicleTypeID != TRUNC(p_VehicleTypeID) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Vehicle type ID must be an integer (non-fractional number).');
    END IF;

    IF p_VehicleTypeID < 1 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Vehicle type ID must be greater than or equal to 1.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Orders delivered using vehicle type ID ' || p_VehicleTypeID || ':');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');

    FOR order_rec IN orders_cursor LOOP
        v_row_count := v_row_count + 1;

        DBMS_OUTPUT.PUT_LINE(
            'Order ID: ' || order_rec.ORDER_ID ||
            ', Client ID: ' || order_rec.CLIENT_ID ||
            ', Driver ID: ' || order_rec.DRIVER_ID ||
            ', Service ID: ' || order_rec.SERVICE_ID ||
            ', Status: ' || order_rec.STATUS ||
            ', Created At: ' || TO_CHAR(order_rec.CREATED_AT, 'YYYY-MM-DD HH24:MI:SS') ||
            ', Delivered At: ' || TO_CHAR(order_rec.DELIVERED_AT, 'YYYY-MM-DD HH24:MI:SS') ||
            ', Total Weight: ' || order_rec.TOTAL_WEIGHT || ' kg' ||
            ', Total Volume: ' || order_rec.TOTAL_VOLUME || ' m^3'
        );
    END LOOP;

    IF v_row_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No orders found for the specified vehicle type.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'An error occurred: ' || SQLERRM);
END;

BEGIN
    GET_ORDERS_BY_VEHICLE_TYPE(1);
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'GET_ORDERS_BY_VEHICLE_TYPE';

SELECT * 
FROM user_errors 
WHERE name = 'GET_ORDERS_BY_VEHICLE_TYPE' AND type = 'PROCEDURE';

-- Обновить данные клиента
CREATE OR REPLACE PROCEDURE UpdateClientInfo (
    p_ClientID IN NUMBER,
    p_FirstName IN NVARCHAR2,
    p_LastName IN NVARCHAR2,
    p_MiddleName IN NVARCHAR2,
    p_Address IN NVARCHAR2,
    p_Email IN NVARCHAR2,
    p_PhoneNumber IN NVARCHAR2
) AS
BEGIN
    UPDATE CLIENT_INFO
    SET FIRST_NAME = p_FirstName,
        LAST_NAME = p_LastName,
        MIDDLE_NAME = p_MiddleName,
        ADDRESS = p_Address,
        EMAIL = p_Email,
        PHONE_NUMBER = p_PhoneNumber
    WHERE CLIENT_ID = p_ClientID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Client with ID ' || p_ClientID || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Client info updated successfully.');
    END IF;
END UpdateClientInfo;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'UPDATECLIENTINFO';

SELECT * 
FROM user_errors 
WHERE name = 'UPDATECLIENTINFO' AND type = 'PROCEDURE';

BEGIN 
	UpdateClientInfo(1, 'UpdatedFirst', 'UpdatedLast', 'UpdatedM', 'Updated Address', 'updated@example.com', '1234567890');
END;

-- Обновить информацию о грузе
CREATE OR REPLACE PROCEDURE UpdateCargoInfo (
    p_CargoID IN NUMBER,
    p_Name IN NVARCHAR2,
    p_Description IN NVARCHAR2,
    p_Weight IN NUMBER,
    p_Volume IN NUMBER,
    p_CargoType IN NUMBER,
    p_Hazardous IN NVARCHAR2
) AS
BEGIN
    UPDATE CARGO
    SET NAME = p_Name,
        DESCRIPTION = p_Description,
        WEIGHT = p_Weight,
        VOLUME = p_Volume,
        CARGO_TYPE = p_CargoType,
        HAZARDOUS = p_Hazardous
    WHERE ID = p_CargoID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Cargo with ID ' || p_CargoID || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cargo info updated successfully.');
    END IF;
END UpdateCargoInfo;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'UPDATECARGOINFO';

SELECT * 
FROM user_errors 
WHERE name = 'UPDATECARGOINFO' AND type = 'PROCEDURE';

BEGIN
	UpdateCargoInfo(2, 'Updated Cargo', 'Updated Description', 150.00, 2.00, 1, 'No');
END;

-- Получить все услуги
CREATE OR REPLACE PROCEDURE GetAllServices AS
BEGIN
    FOR service_rec IN (SELECT * FROM SERVICES) LOOP
        DBMS_OUTPUT.PUT_LINE('Service ID: ' || service_rec.ID || ', Name: ' || service_rec.NAME || ', Base Rate: ' || service_rec.BASE_RATE);
    END LOOP;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No services found.');
    END IF;
END GetAllServices;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'GETALLSERVICES';

SELECT * 
FROM user_errors 
WHERE name = 'GETALLSERVICES' AND type = 'PROCEDURE';

BEGIN
	GetAllServices();
END;

-- Получить информацию о всех клиентах
CREATE OR REPLACE PROCEDURE GetAllClients AS
BEGIN
    FOR client_rec IN (
        SELECT ci.FIRST_NAME, ci.LAST_NAME, ci.EMAIL, ci.PHONE_NUMBER
        FROM CLIENT_INFO ci
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Client Name: ' || client_rec.FIRST_NAME || ' ' || client_rec.LAST_NAME || ', Email: ' || client_rec.EMAIL || ', Phone: ' || client_rec.PHONE_NUMBER);
    END LOOP;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No clients found.');
    END IF;
END GetAllClients;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'GETALLCLIENTS';

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTS' AND type = 'PROCEDURE';


begin
GetAllClients;
END;
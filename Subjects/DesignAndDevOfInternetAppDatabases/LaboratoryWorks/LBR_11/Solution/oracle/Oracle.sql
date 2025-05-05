CREATE OR REPLACE FUNCTION GetOrdersByDateRange(
    StartDate IN DATE, 
    EndDate IN DATE
) RETURN OrderInfoTable PIPELINED AS 
BEGIN
    FOR rec IN (
        SELECT 
            o.ID AS OrderID,
            c.LOGIN AS ClientLogin,
            cinfo.FIRST_NAME AS ClientFirstName,
            cinfo.LAST_NAME AS ClientLastName,
            d.LOGIN AS DriverLogin,
            dinfo.FIRST_NAME AS DriverFirstName,
            dinfo.LAST_NAME AS DriverLastName,
            o.CREATED_AT,
            o.DELIVERED_AT,
            o.STATUS,
            o.TOTAL_WEIGHT,
            o.TOTAL_VOLUME
        FROM 
            ORDERS o
        JOIN 
            CLIENT c ON o.CLIENT_ID = c.ID
        JOIN 
            CLIENT_INFO cinfo ON cinfo.CLIENT_ID = c.ID
        LEFT JOIN 
            DRIVER d ON o.DRIVER_ID = d.ID
        LEFT JOIN 
            DRIVER_INFO dinfo ON dinfo.DRIVER_ID = d.ID
        WHERE 
            o.CREATED_AT BETWEEN StartDate AND EndDate
    ) LOOP
        PIPE ROW (OrderInfoRow(
            rec.OrderID, 
            rec.ClientLogin, 
            rec.ClientFirstName, 
            rec.ClientLastName, 
            rec.DriverLogin, 
            rec.DriverFirstName, 
            rec.DriverLastName, 
            rec.CREATED_AT, 
            rec.DELIVERED_AT, 
            rec.STATUS, 
            rec.TOTAL_WEIGHT, 
            rec.TOTAL_VOLUME
        ));
    END LOOP;
    RETURN;
END;

CREATE OR REPLACE TYPE OrderInfoRow AS OBJECT (
    OrderID NUMBER,
    ClientLogin NVARCHAR2(255),
    ClientFirstName NVARCHAR2(50),
    ClientLastName NVARCHAR2(50),
    DriverLogin NVARCHAR2(255),
    DriverFirstName NVARCHAR2(50),
    DriverLastName NVARCHAR2(50),
    CREATED_AT DATE,
    DELIVERED_AT DATE,
    STATUS NVARCHAR2(50),
    TOTAL_WEIGHT DECIMAL(10, 2),
    TOTAL_VOLUME DECIMAL(10, 2)
);

CREATE OR REPLACE TYPE OrderInfoTable AS TABLE OF OrderInfoRow;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION' AND OBJECT_NAME = ' GETORDERSBYDATERANGE';

SELECT * 
FROM user_errors 
WHERE name = ' GETORDERSBYDATERANGE' AND type = 'FUNCTION';

SELECT * FROM TABLE(GetOrdersByDateRange(DATE '2025-04-13', DATE '2025-04-16'));
SELECT * FROM ORDERS;


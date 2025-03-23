-- Получить информацию о транспортном средстве по ID
CREATE FUNCTION dbo.GetVehicleInfoByID
    (@VehicleID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM VEHICLE
    WHERE ID = @VehicleID
);

SELECT *
FROM sys.objects
WHERE name = 'GetVehicleInfoByID' AND type IN ('FN', 'IF', 'TF');

DECLARE @VehicleID INT = 1; 
SELECT * FROM dbo.GetVehicleInfoByID(@VehicleID);

-- Получить все виды услуг по типу
CREATE FUNCTION GetServicesByType
    @ServiceTypeID INT
RETURNS TABLE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SERVICE_TYPE WHERE ID = @ServiceTypeID)
    BEGIN
        RAISERROR('Service type with ID %d does not exist.', 16, 1, @ServiceTypeID);
        RETURN;
    END

    RETURN
    (
        SELECT *
        FROM SERVICES
        WHERE SERVICE_TYPE_ID = @ServiceTypeID
    );
END;

DECLARE @ServiceTypeID INT = 1; 
SELECT * FROM GetServicesByType(@ServiceTypeID);

-- Получить все активные транспортные средства
CREATE FUNCTION GetActiveVehicles()
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM VEHICLE
    WHERE STATUS = 'Available'
);

SELECT * FROM GetActiveVehicles();

-- Получить все грузы определенного типа
CREATE FUNCTION GetCargoByType
(
    @CargoTypeID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM CARGO
    WHERE CARGO_TYPE = @CargoTypeID
);

DECLARE @CargoTypeID INT = 1;
SELECT * FROM GetCargoByType(@CargoTypeID);

-- Функция для получения списка клиентов, которые сделали заказы на сумму больше определенной:
CREATE FUNCTION GetClientsWithOrdersAboveAmount(@p_Amount DECIMAL(10, 2))
RETURNS TABLE
AS
RETURN (
    SELECT 
        c.ID AS CLIENT_ID, 
        ci.FIRST_NAME, 
        ci.LAST_NAME, 
        SUM(o.TOTAL_WEIGHT) AS TOTAL_ORDER_AMOUNT
    FROM 
        CLIENT c
    JOIN 
        CLIENT_INFO ci ON c.ID = ci.CLIENT_ID
    JOIN 
        ORDERS o ON c.ID = o.CLIENT_ID
    GROUP BY 
        c.ID, ci.FIRST_NAME, ci.LAST_NAME
    HAVING 
        SUM(o.TOTAL_WEIGHT) > @p_Amount
    AND @p_Amount > 0  
);

SELECT * FROM GetClientsWithOrdersAboveAmount(399.00);






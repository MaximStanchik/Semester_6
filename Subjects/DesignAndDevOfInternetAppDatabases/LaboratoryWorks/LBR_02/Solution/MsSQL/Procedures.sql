-- Получить все грузы
CREATE PROCEDURE GetAllCargo
AS
BEGIN
    SELECT * FROM CARGO;
END;

EXEC GetAllCargo;

-- Удалить груз по ID
CREATE PROCEDURE DeleteCargo
    @CargoID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM CARGO WHERE ID = @CargoID)
        BEGIN
            RAISERROR('Cargo with ID %d does not exist.', 16, 1, @CargoID);
            RETURN;
        END

        DELETE FROM CARGO WHERE ID = @CargoID;

        SELECT 'Cargo deleted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

INSERT INTO CARGO (NAME, DESCRIPTION, WEIGHT, VOLUME, CARGO_TYPE, HAZARDOUS) VALUES ('Silly String', 'Endless fun string', 200.00, 3.00, 2, 'No');
select * from CARGO;
EXEC DeleteCargo @CargoID = 12;

-- Добавить новый заказ
CREATE PROCEDURE AddOrder
    @ClientID INT,
    @DriverID INT,
    @ServiceID INT,
    @Status NVARCHAR(50),
    @Route INT,
    @DeliveryType NVARCHAR(50),
    @TotalWeight DECIMAL(10, 2),
    @TotalVolume DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM CLIENT WHERE ID = @ClientID)
        BEGIN
            RAISERROR('Client with ID %d does not exist.', 16, 1, @ClientID);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM DRIVER WHERE ID = @DriverID)
        BEGIN
            RAISERROR('Driver with ID %d does not exist.', 16, 1, @DriverID);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM SERVICES WHERE ID = @ServiceID)
        BEGIN
            RAISERROR('Service with ID %d does not exist.', 16, 1, @ServiceID);
            RETURN;
        END

        DECLARE @ValidStatuses TABLE (Status NVARCHAR(50));
        INSERT INTO @ValidStatuses (Status) VALUES ('Pending'), ('In Transit'), ('Delivered'), ('Cancelled'), ('On Hold'), ('Returned'), ('Lost');

        IF NOT EXISTS (SELECT 1 FROM @ValidStatuses WHERE Status = @Status)
        BEGIN
            RAISERROR('Invalid status: %s. Valid statuses are: Pending, In Transit, Delivered, Cancelled, On Hold, Returned, Lost.', 16, 1, @Status);
            RETURN;
        END

        INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME)
        VALUES (@ClientID, @DriverID, @ServiceID, @Status, @Route, @DeliveryType, @TotalWeight, @TotalVolume);

        SELECT 'Order added successfully.' AS Message;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

EXEC AddOrder 
    @ClientID = 1,         
    @DriverID = 1,         
    @ServiceID = 1,        
    @Status = 'Pending',    
    @Route = 1,            
    @DeliveryType = 'Standard', 
    @TotalWeight = 100.00,  
    @TotalVolume = 1.00;   
   
  select * from ORDERS;

-- Обновить статус заказа
CREATE PROCEDURE UpdateOrderStatus
    @OrderID INT,
    @Status NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE ID = @OrderID)
        BEGIN
            RAISERROR('Order with ID %d does not exist.', 16, 1, @OrderID);
            RETURN;
        END

        DECLARE @ValidStatuses TABLE (Status NVARCHAR(50));
        INSERT INTO @ValidStatuses (Status) VALUES ('Pending'), ('In Transit'), ('Delivered'), ('Cancelled'), ('On Hold'), ('Returned'), ('Lost');

        IF NOT EXISTS (SELECT 1 FROM @ValidStatuses WHERE Status = @Status)
        BEGIN
            RAISERROR('Invalid status: %s. Valid statuses are: Pending, In Transit, Delivered, Cancelled, On Hold, Returned, Lost.', 16, 1, @Status);
            RETURN;
        END

        UPDATE ORDERS SET STATUS = @Status WHERE ID = @OrderID;

        SELECT 'Order status updated successfully.' AS Message;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

EXEC UpdateOrderStatus 
    @OrderID = 4,         
    @Status = 'Delivered';
   
select * from ORDERS;

-- Получить информацию о водителе и его транспортных средствах
CREATE PROCEDURE GetDriverAndVehicles
    @DriverID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM DRIVER WHERE ID = @DriverID)
        BEGIN
            RAISERROR('Driver with ID %d does not exist.', 16, 1, @DriverID);
            RETURN;
        END

        SELECT D.*, V.*
        FROM DRIVER D
        LEFT JOIN VEHICLE V ON D.ID = V.DRIVER_ID
        WHERE D.ID = @DriverID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No vehicles found for the driver with ID %d.', 16, 1, @DriverID);
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

EXEC GetDriverAndVehicles 
    @DriverID = 1;
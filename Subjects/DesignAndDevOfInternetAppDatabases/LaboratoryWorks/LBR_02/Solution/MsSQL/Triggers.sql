-- Триггер для обновления времени доставки
CREATE TRIGGER trg_UpdateDeliveredAt
ON ORDERS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE STATUS = 'Delivered')
    BEGIN
        UPDATE ORDERS
        SET DELIVERED_AT = GETDATE()
        WHERE ID IN (SELECT ID FROM inserted WHERE STATUS = 'Delivered');
    END
END;
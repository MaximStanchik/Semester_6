-- Автоматическое обновление статуса транспортного средства при назначении/освобождении водителя
CREATE OR REPLACE TRIGGER trg_vehicle_status_update
AFTER UPDATE ON DRIVER_INFO
FOR EACH ROW
BEGIN
    IF :NEW.VEHICLE_INFO IS NOT NULL THEN
        UPDATE VEHICLE
        SET STATUS = 'Busy',
            DRIVER_ID = :NEW.DRIVER_ID 
        WHERE ID = :NEW.VEHICLE_INFO;
    END IF;

    IF :OLD.VEHICLE_INFO IS NOT NULL AND :NEW.VEHICLE_INFO IS NULL THEN
        UPDATE VEHICLE
        SET STATUS = 'Available',
            DRIVER_ID = NULL
        WHERE ID = :OLD.VEHICLE_INFO;
    END IF;
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'TRIGGER' AND OBJECT_NAME = 'trg_vehicle_status_update';

SELECT * 
FROM user_errors 
WHERE name = 'trg_vehicle_status_update' AND type = 'TRIGGER';

-- Автоматическая проверка назначен ли водитель
CREATE OR REPLACE TRIGGER trg_vehicle_driver_update
BEFORE UPDATE OF DRIVER_ID ON VEHICLE
FOR EACH ROW
BEGIN
IF :NEW.DRIVER_ID IS NULL THEN
:NEW.STATUS := 'Available';
ELSE
IF :OLD.DRIVER_ID IS NULL THEN
:NEW.STATUS := 'Busy';
END IF;
END IF;
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'TRIGGER' AND OBJECT_NAME = 'trg_vehicle_driver_update';

SELECT * FROM user_errors 
WHERE name = 'trg_vehicle_driver_update' AND type = 'TRIGGER';

-- демонстрация работоспособности триггеров: 

SELECT * FROM driver_info  WHERE driver_id = 9;
SELECT * FROM vehicle WHERE id = 14;

UPDATE driver_info SET vehicle_info = null  WHERE driver_id = 9;
UPDATE vehicle SET status = 'Busy' WHERE id = 14;
UPDATE driver_info SET vehicle_info = null WHERE driver_id = 9;

SELECT * FROM vehicle WHERE id = 14;
UPDATE vehicle SET DRIVER_ID = null WHERE id = 14;

SELECT * FROM driver_info;

SELECT * FROM orders;
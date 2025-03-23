-- Получить информации о грузах и их типах
	CREATE VIEW CargoTypeInfo AS
	SELECT c.ID AS CargoID, c.NAME AS CargoName, ct.NAME AS CargoType, c.HAZARDOUS FROM CARGO c
	JOIN CARGO_TYPE ct ON c.CARGO_TYPE = ct.ID;

	SELECT * FROM CargoTypeInfo; 
    
-- Получить информацию о транспортных средствах и их водителях
   CREATE VIEW VehicleDriverInfo AS
   SELECT v.ID AS VehicleID, v.LICENSE_PLATE, v.MODEL, vt.NAME AS VehicleType, di.FIRST_NAME AS DriverFirstName, di.LAST_NAME AS DriverLastName FROM VEHICLE v
   JOIN VEHICLE_TYPE vt ON v.VEHICLE_TYPE = vt.ID
   JOIN DRIVER d ON v.DRIVER_ID = d.ID
   JOIN DRIVER_INFO di ON d.ID = di.DRIVER_ID;
    
   SELECT * FROM VehicleDriverInfo; 
   
-- Получить информацию об услугах и их типах
   CREATE VIEW ServiceTypeInfo AS 
   SELECT s.ID AS ServiceID, s.NAME AS ServiceName, st.NAME AS ServiceType, s.BASE_RATE 
   FROM SERVICES s JOIN SERVICE_TYPE st ON s.SERVICE_TYPE_ID = st.ID;
   
   SELECT * FROM ServiceTypeInfo; 
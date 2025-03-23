-- Получить инфомрацию о клиентах и их заказах
create view ClientOrdersSummary as
select c.ID as ClientID, ci.FIRST_NAME, ci.LAST_NAME, count(o.ID) as TotalOrders, sum(o.TOTAL_WEIGHT) as TotalWeight
from client c join client_info ci on c.ID = ci.client_id left join orders o ON c.ID = o.CLIENT_ID group by c.ID, ci.FIRST_NAME, ci.LAST_NAME;

SELECT * FROM ClientOrdersSummary; 

-- Получить информацию о водителях и их транспортных средствах
create view DriverVehicleInfo as select 
d.ID as DriverID, di.FIRST_NAME, di.LAST_NAME, v.LICENSE_PLATE, vt.NAME as VehicleType, v.STATUS as VehicleStatus 
from DRIVER d join DRIVER_INFO di On d.ID = di.DRIVER_ID join VEHICLE v on d.ID = v.DRIVER_ID join VEHICLE_TYPE vt ON v.VEHICLE_TYPE = vt.ID;

SELECT * FROM DriverVehicleInfo; 
	
-- Получить информацию о заказах и их статусах
CREATE VIEW OrderStatusInfo AS
SELECT o.ID AS OrderID, o.STATUS, o.DELIVERY_TYPE, r.START_LOCATION, r.END_LOCATION, o.CREATED_AT, o.DELIVERED_AT 
from ORDERS o JOIN ROUTES r ON o.ROUTE = r.ID;

SELECT * FROM OrderStatusInfo; 
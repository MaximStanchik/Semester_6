--- 1 Добавить в бд достаточное число правдоподобных данных. Можно генерировать данные и/или использовать импорт. 

INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES 
(1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL),
(2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, NULL),
(3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -30, GETDATE())), -- 1 месяц назад
(4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, NULL),
(5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(MONTH, -6, GETDATE())), -- 6 месяцев назад
(6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(YEAR, -1, GETDATE())), -- 1 год назад
(7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, NULL),
(8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(DAY, -15, GETDATE())), -- 15 дней назад
(9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(DAY, -90, GETDATE())), -- 3 месяца назад
(10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(DAY, -200, GETDATE())), -- 200 дней назад
(1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL),
(2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, DATEADD(DAY, -45, GETDATE())), -- 45 дней назад
(3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -10, GETDATE())), -- 10 дней назад
(4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, NULL),
(5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(MONTH, -1, GETDATE())), -- 1 месяц назад
(6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(YEAR, -1, GETDATE())), -- 1 год назад
(7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, DATEADD(DAY, -60, GETDATE())), -- 2 месяца назад
(8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(DAY, -75, GETDATE())), -- 75 дней назад
(9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(DAY, -120, GETDATE())), -- 4 месяца назад
(10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(MONTH, -8, GETDATE())), -- 8 месяцев назад
(1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL),
(2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, DATEADD(DAY, -30, GETDATE())), -- 30 дней назад
(3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -200, GETDATE())), -- 200 дней назад
(4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, DATEADD(DAY, -15, GETDATE())), -- 15 дней назад
(5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(MONTH, -6, GETDATE())), -- 6 месяцев назад
(6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(YEAR, -1, GETDATE())), -- 1 год назад
(7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, DATEADD(DAY, -30, GETDATE())), -- 30 дней назад
(8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(DAY, -90, GETDATE())), -- 90 дней назад
(9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(DAY, -45, GETDATE())), -- 45 дней назад
(10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(DAY, -10, GETDATE())), -- 10 дней назад
(1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL),
(2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, DATEADD(DAY, -60, GETDATE())), -- 60 дней назад
(3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -150, GETDATE())), -- 150 дней назад
(4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, DATEADD(DAY, -120, GETDATE())), -- 120 дней назад
(5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(DAY, -200, GETDATE())), -- 200 дней назад
(6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(MONTH, -2, GETDATE())), -- 2 месяца назад
(7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, DATEADD(DAY, -180, GETDATE())), -- 180 дней назад
(8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(MONTH, -3, GETDATE())), -- 3 месяца назад
(9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(MONTH, -4, GETDATE())), -- 4 месяца назад
(10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(MONTH, -5, GETDATE())); -- 5 месяцев назад

SELECT * FROM ORDERS; 

-- 4 Вычисление итогов предоставленных услуг за определенный период:
-- •	объем услуг;
-- •	сравнение их с общим объемом услуг (в %);
-- •	сравнение с максимальным объемом услуг (в %).

CREATE OR ALTER PROCEDURE CalculateServiceVolumeAnalysis
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        PeriodStats.PeriodTotalWeight,
        PeriodStats.PeriodTotalVolume,
        
        CASE WHEN TotalStats.TotalWeight > 0 
             THEN ROUND((PeriodStats.PeriodTotalWeight / TotalStats.TotalWeight) * 100, 2) 
             ELSE 0 END AS WeightPercentageOfTotal,
        CASE WHEN TotalStats.TotalVolume > 0 
             THEN ROUND((PeriodStats.PeriodTotalVolume / TotalStats.TotalVolume) * 100, 2) 
             ELSE 0 END AS VolumePercentageOfTotal,
        
        CASE WHEN MaxStats.MaxWeight > 0 
             THEN ROUND((PeriodStats.PeriodTotalWeight / MaxStats.MaxWeight) * 100, 2) 
             ELSE 0 END AS WeightPercentageOfMax,
        CASE WHEN MaxStats.MaxVolume > 0 
             THEN ROUND((PeriodStats.PeriodTotalVolume / MaxStats.MaxVolume) * 100, 2) 
             ELSE 0 END AS VolumePercentageOfMax,
        
        TotalStats.TotalWeight AS AllTimeTotalWeight,
        TotalStats.TotalVolume AS AllTimeTotalVolume,
        MaxStats.MaxWeight AS MaxSingleOrderWeight,
        MaxStats.MaxVolume AS MaxSingleOrderVolume,
        @StartDate AS AnalysisStartDate,
        @EndDate AS AnalysisEndDate
    FROM 
        (SELECT 
            SUM(CASE WHEN (DELIVERED_AT BETWEEN @StartDate AND @EndDate)
                      OR (STATUS IN ('Delivered', 'Completed') AND CREATED_AT BETWEEN @StartDate AND @EndDate)
                 THEN TOTAL_WEIGHT ELSE 0 END) AS PeriodTotalWeight,
            SUM(CASE WHEN (DELIVERED_AT BETWEEN @StartDate AND @EndDate)
                      OR (STATUS IN ('Delivered', 'Completed') AND CREATED_AT BETWEEN @StartDate AND @EndDate)
                 THEN TOTAL_VOLUME ELSE 0 END) AS PeriodTotalVolume
         FROM ORDERS) AS PeriodStats,
        
        (SELECT 
            SUM(TOTAL_WEIGHT) AS TotalWeight,
            SUM(TOTAL_VOLUME) AS TotalVolume
         FROM ORDERS
         WHERE STATUS IN ('Delivered', 'Completed')) AS TotalStats,
        
        (SELECT 
            MAX(TOTAL_WEIGHT) AS MaxWeight,
            MAX(TOTAL_VOLUME) AS MaxVolume
         FROM ORDERS
         WHERE STATUS IN ('Delivered', 'Completed')) AS MaxStats;
END;

begin 
	EXEC CalculateServiceVolumeAnalysis 
    @StartDate = '2025-03-01', 
    @EndDate = '2025-03-31'
end

-- 3 Вычисление итогов предоставленных услуг помесячно, за квартал, за полгода, за год.

CREATE OR ALTER PROCEDURE AnalyzeServicesByPeriods
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #ServiceAnalysis (
        PeriodType NVARCHAR(20),
        PeriodName NVARCHAR(30),
        TotalOrders INT,
        TotalWeight DECIMAL(15, 2),
        TotalVolume DECIMAL(15, 2),
        AvgWeight DECIMAL(15, 2),
        AvgVolume DECIMAL(15, 2),
        StartDate DATE,
        EndDate DATE,
        PeriodOrder INT
    );

    WITH MonthlyData AS (
        SELECT 
            YEAR(DELIVERED_AT) AS YearNum,
            MONTH(DELIVERED_AT) AS MonthNum,
            COUNT(*) AS TotalOrders,
            SUM(TOTAL_WEIGHT) AS TotalWeight,
            SUM(TOTAL_VOLUME) AS TotalVolume,
            AVG(TOTAL_WEIGHT) AS AvgWeight,
            AVG(TOTAL_VOLUME) AS AvgVolume,
            MIN(DELIVERED_AT) AS StartDate,
            MAX(DELIVERED_AT) AS EndDate
        FROM ORDERS
        WHERE STATUS IN ('Delivered', 'Completed')
          AND DELIVERED_AT BETWEEN @StartDate AND @EndDate
        GROUP BY YEAR(DELIVERED_AT), MONTH(DELIVERED_AT)
    )
    INSERT INTO #ServiceAnalysis
    SELECT 
        'Monthly' AS PeriodType,
        FORMAT(DATEFROMPARTS(YearNum, MonthNum, 1), 'yyyy-MM') AS PeriodName,
        TotalOrders,
        TotalWeight,
        TotalVolume,
        AvgWeight,
        AvgVolume,
        StartDate,
        EndDate,
        YearNum * 100 + MonthNum AS PeriodOrder
    FROM MonthlyData
    ORDER BY PeriodOrder;

    WITH QuarterlyData AS (
        SELECT 
            YEAR(DELIVERED_AT) AS YearNum,
            DATEPART(QUARTER, DELIVERED_AT) AS QuarterNum,
            COUNT(*) AS TotalOrders,
            SUM(TOTAL_WEIGHT) AS TotalWeight,
            SUM(TOTAL_VOLUME) AS TotalVolume,
            AVG(TOTAL_WEIGHT) AS AvgWeight,
            AVG(TOTAL_VOLUME) AS AvgVolume,
            MIN(DELIVERED_AT) AS StartDate,
            MAX(DELIVERED_AT) AS EndDate
        FROM ORDERS
        WHERE STATUS IN ('Delivered', 'Completed')
          AND DELIVERED_AT BETWEEN @StartDate AND @EndDate
        GROUP BY YEAR(DELIVERED_AT), DATEPART(QUARTER, DELIVERED_AT)
    )
    INSERT INTO #ServiceAnalysis
    SELECT 
        'Quarterly' AS PeriodType,
        CONCAT('Q', QuarterNum, ' ', YearNum) AS PeriodName,
        TotalOrders,
        TotalWeight,
        TotalVolume,
        AvgWeight,
        AvgVolume,
        StartDate,
        EndDate,
        YearNum * 10 + QuarterNum AS PeriodOrder
    FROM QuarterlyData
    ORDER BY PeriodOrder;

    WITH HalfYearData AS (
        SELECT 
            YEAR(DELIVERED_AT) AS YearNum,
            CASE WHEN DATEPART(MONTH, DELIVERED_AT) BETWEEN 1 AND 6 THEN 1 ELSE 2 END AS HalfYearNum,
            COUNT(*) AS TotalOrders,
            SUM(TOTAL_WEIGHT) AS TotalWeight,
            SUM(TOTAL_VOLUME) AS TotalVolume,
            AVG(TOTAL_WEIGHT) AS AvgWeight,
            AVG(TOTAL_VOLUME) AS AvgVolume,
            MIN(DELIVERED_AT) AS StartDate,
            MAX(DELIVERED_AT) AS EndDate
        FROM ORDERS
        WHERE STATUS IN ('Delivered', 'Completed')
          AND DELIVERED_AT BETWEEN @StartDate AND @EndDate
        GROUP BY YEAR(DELIVERED_AT), 
                 CASE WHEN DATEPART(MONTH, DELIVERED_AT) BETWEEN 1 AND 6 THEN 1 ELSE 2 END
    )
    INSERT INTO #ServiceAnalysis
    SELECT 
        'Half-Year' AS PeriodType,
        CONCAT('H', HalfYearNum, ' ', YearNum) AS PeriodName,
        TotalOrders,
        TotalWeight,
        TotalVolume,
        AvgWeight,
        AvgVolume,
        StartDate,
        EndDate,
        YearNum * 10 + HalfYearNum AS PeriodOrder
    FROM HalfYearData
    ORDER BY PeriodOrder;

    WITH YearlyData AS (
        SELECT 
            YEAR(DELIVERED_AT) AS YearNum,
            COUNT(*) AS TotalOrders,
            SUM(TOTAL_WEIGHT) AS TotalWeight,
            SUM(TOTAL_VOLUME) AS TotalVolume,
            AVG(TOTAL_WEIGHT) AS AvgWeight,
            AVG(TOTAL_VOLUME) AS AvgVolume,
            MIN(DELIVERED_AT) AS StartDate,
            MAX(DELIVERED_AT) AS EndDate
        FROM ORDERS
        WHERE STATUS IN ('Delivered', 'Completed')
          AND DELIVERED_AT BETWEEN @StartDate AND @EndDate
        GROUP BY YEAR(DELIVERED_AT)
    )
    INSERT INTO #ServiceAnalysis
    SELECT 
        'Yearly' AS PeriodType,
        CAST(YearNum AS NVARCHAR(4)) AS PeriodName,
        TotalOrders,
        TotalWeight,
        TotalVolume,
        AvgWeight,
        AvgVolume,
        StartDate,
        EndDate,
        YearNum AS PeriodOrder
    FROM YearlyData
    ORDER BY PeriodOrder;

    INSERT INTO #ServiceAnalysis
    SELECT 
        'Total Period' AS PeriodType,
        CONCAT(FORMAT(@StartDate, 'yyyy-MM-dd'), ' - ', FORMAT(@EndDate, 'yyyy-MM-dd')) AS PeriodName,
        COUNT(*) AS TotalOrders,
        SUM(TOTAL_WEIGHT) AS TotalWeight,
        SUM(TOTAL_VOLUME) AS TotalVolume,
        AVG(TOTAL_WEIGHT) AS AvgWeight,
        AVG(TOTAL_VOLUME) AS AvgVolume,
        @StartDate AS StartDate,
        @EndDate AS EndDate,
        999999 AS PeriodOrder
    FROM ORDERS
    WHERE STATUS IN ('Delivered', 'Completed')
      AND DELIVERED_AT BETWEEN @StartDate AND @EndDate;

    SELECT 
        PeriodType,
        PeriodName,
        TotalOrders,
        TotalWeight,
        TotalVolume,
        AvgWeight,
        AvgVolume,
        FORMAT(StartDate, 'yyyy-MM-dd') AS StartDate,
        FORMAT(EndDate, 'yyyy-MM-dd') AS EndDate,
        CASE WHEN SUM(TotalWeight) OVER() > 0 
             THEN ROUND(TotalWeight * 100.0 / SUM(TotalWeight) OVER(), 2) 
             ELSE 0 END AS WeightPercentageOfTotal,
        CASE WHEN SUM(TotalVolume) OVER() > 0 
             THEN ROUND(TotalVolume * 100.0 / SUM(TotalVolume) OVER(), 2) 
             ELSE 0 END AS VolumePercentageOfTotal
    FROM #ServiceAnalysis
    ORDER BY 
        CASE PeriodType
            WHEN 'Monthly' THEN 1
            WHEN 'Quarterly' THEN 2
            WHEN 'Half-Year' THEN 3
            WHEN 'Yearly' THEN 4
            ELSE 5
        END,
        PeriodOrder;

    DROP TABLE #ServiceAnalysis;
END;

begin
	EXEC AnalyzeServicesByPeriods 
    @StartDate = '2025-03-01', 
    @EndDate = '2025-03-31'
end;

-- 5 Продемонстрируйте применение функции ранжирования ROW_NUMBER() для разбиения результатов запроса на страницы (по 20 строк на каждую страницу). 

-- Процедура для постраничного вывода заказов
CREATE OR ALTER PROCEDURE GetOrdersPaginated
    @PageNumber INT = 1,
    @PageSize INT = 20,
    @SortColumn NVARCHAR(50) = 'ID',
    @SortDirection NVARCHAR(4) = 'ASC'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Валидация параметров
    IF @PageNumber < 1 SET @PageNumber = 1;
    IF @PageSize < 1 SET @PageSize = 20;
    
    -- Основной запрос с пагинацией
    WITH PaginatedOrders AS (
        SELECT 
            o.ID,
            c.LOGIN AS ClientLogin,
            ci.FIRST_NAME + ' ' + ci.LAST_NAME AS ClientName,
            d.LOGIN AS DriverLogin,
            di.FIRST_NAME + ' ' + di.LAST_NAME AS DriverName,
            s.NAME AS ServiceName,
            o.STATUS,
            o.CREATED_AT,
            o.DELIVERED_AT,
            o.TOTAL_WEIGHT,
            o.TOTAL_VOLUME,
            r.START_LOCATION,
            r.END_LOCATION,
            r.DISTANCE,
            -- Применяем ROW_NUMBER() для нумерации строк с учетом сортировки
            ROW_NUMBER() OVER (
                ORDER BY 
                    CASE WHEN @SortColumn = 'ID' AND @SortDirection = 'ASC' THEN o.ID END ASC,
                    CASE WHEN @SortColumn = 'ID' AND @SortDirection = 'DESC' THEN o.ID END DESC,
                    CASE WHEN @SortColumn = 'ClientName' AND @SortDirection = 'ASC' THEN ci.FIRST_NAME + ' ' + ci.LAST_NAME END ASC,
                    CASE WHEN @SortColumn = 'ClientName' AND @SortDirection = 'DESC' THEN ci.FIRST_NAME + ' ' + ci.LAST_NAME END DESC,
                    CASE WHEN @SortColumn = 'CreatedAt' AND @SortDirection = 'ASC' THEN o.CREATED_AT END ASC,
                    CASE WHEN @SortColumn = 'CreatedAt' AND @SortDirection = 'DESC' THEN o.CREATED_AT END DESC,
                    CASE WHEN @SortColumn = 'TotalWeight' AND @SortDirection = 'ASC' THEN o.TOTAL_WEIGHT END ASC,
                    CASE WHEN @SortColumn = 'TotalWeight' AND @SortDirection = 'DESC' THEN o.TOTAL_WEIGHT END DESC
            ) AS RowNum,
            COUNT(*) OVER() AS TotalCount
        FROM ORDERS o
        JOIN CLIENT c ON o.CLIENT_ID = c.ID
        JOIN CLIENT_INFO ci ON c.ID = ci.CLIENT_ID
        LEFT JOIN DRIVER d ON o.DRIVER_ID = d.ID
        LEFT JOIN DRIVER_INFO di ON d.ID = di.DRIVER_ID
        JOIN SERVICES s ON o.SERVICE_ID = s.ID
        JOIN ROUTES r ON o.ROUTE = r.ID
    )
    SELECT 
        ID,
        ClientLogin,
        ClientName,
        DriverLogin,
        DriverName,
        ServiceName,
        STATUS,
        CREATED_AT,
        DELIVERED_AT,
        TOTAL_WEIGHT,
        TOTAL_VOLUME,
        START_LOCATION,
        END_LOCATION,
        DISTANCE,
        TotalCount,
        CEILING(TotalCount * 1.0 / @PageSize) AS TotalPages
    FROM PaginatedOrders
    WHERE RowNum BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber * @PageSize
    ORDER BY RowNum;
END;

-- Первая страница (20 записей), сортировка по ID по возрастанию:
EXEC GetOrdersPaginated 
    @PageNumber = 1, 
    @PageSize = 20,
    @SortColumn = 'ID',
    @SortDirection = 'ASC';
   
-- Вторая страница, сортировка по дате создания по убыванию:
EXEC GetOrdersPaginated 
    @PageNumber = 2, 
    @PageSize = 20,
    @SortColumn = 'CreatedAt',
    @SortDirection = 'DESC';
   
-- Сортировка по весу груза по возрастанию
EXEC GetOrdersPaginated 
    @PageNumber = 1, 
    @PageSize = 20,
    @SortColumn = 'TotalWeight',
    @SortDirection = 'ASC';
      
-- 6.	Продемонстрируйте применение функции ранжирования ROW_NUMBER() для удаления дубликатов.
   
CREATE OR ALTER PROCEDURE RemoveDuplicateClientInfo
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH RankedClients AS (
        SELECT 
            ID,
            CLIENT_ID,
            FIRST_NAME,
            LAST_NAME,
            MIDDLE_NAME,
            ADDRESS,
            EMAIL,
            PHONE_NUMBER,
            ROW_NUMBER() OVER (
                PARTITION BY CLIENT_ID, EMAIL 
                ORDER BY ID 
            ) AS RowNum
        FROM CLIENT_INFO
    )
    DELETE FROM RankedClients
    WHERE RowNum > 1; 

    SELECT @@ROWCOUNT AS DeletedCount;
END;

begin
EXEC RemoveDuplicateClientInfo;
end;

select * from CLIENT_INFO;

INSERT INTO CLIENT_INFO (CLIENT_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, EMAIL, PHONE_NUMBER)
VALUES 
    (1, 'Bobby', 'Funster', 'W.', '123 Happy St', 'bobbyfun@example.com', '1234567890'),  -- Дубликат 1
    (2, 'Daisy', 'Wag', 'F.', '456 Silly Ave', 'daisywag@example.com', '2345678901'),      -- Дубликат 2
    (3, 'Penny', 'Slide', 'G.', '789 Chill Blvd', 'pennyslide@example.com', '3456789012'), -- Дубликат 3
    (4, 'Ollie', 'Run', 'H.', '321 Speedy Ln', 'ollierun@example.com', '4567890123'),      -- Дубликат 4
    (5, 'Lenny', 'Spit', 'I.', '654 Spit St', 'lennyspit@example.com', '5678901234'),      -- Дубликат 5
    (6, 'Nina', 'Nutty', 'J.', '987 Nut St', 'ninanuts@example.com', '6789012345'),        -- Дубликат 6
    (7, 'Gary', 'Tall', 'K.', '135 Tall Rd', 'garytall@example.com', '7890123456'),        -- Дубликат 7
    (8, 'Marty', 'Water', 'L.', '246 Splash St', 'martywater@example.com', '8901234567'),  -- Дубликат 8
    (9, 'Otto', 'Swim', 'M.', '357 Swim Ln', 'ottoswim@example.com', '9012345678'),        -- Дубликат 9
    (10, 'Zara', 'Stripe', 'N.', '468 Stripe St', 'zarastripe@example.com', '0123456789');  -- Дубликат 10
    
-- 7.  Вернуть для каждого клиента направления последних 6 заказов.
CREATE OR ALTER PROCEDURE GetLastSixOrdersForClients
AS
BEGIN
    SET NOCOUNT ON;

    WITH RankedOrders AS (
        SELECT 
            o.ID AS OrderID,
            o.CLIENT_ID,
            r.START_LOCATION,
            r.END_LOCATION,
            o.CREATED_AT,
            ROW_NUMBER() OVER (
                PARTITION BY o.CLIENT_ID 
                ORDER BY o.CREATED_AT DESC, o.ID DESC  
            ) AS RowNum
        FROM 
            ORDERS o
        JOIN 
            ROUTES r ON o.ROUTE = r.ID
    )
    SELECT DISTINCT  
        ci.CLIENT_ID,
        ci.FIRST_NAME,
        ci.LAST_NAME,
        ro.OrderID,
        ro.START_LOCATION,
        ro.END_LOCATION,
        ro.CREATED_AT
    FROM 
        RankedOrders ro
    JOIN 
        CLIENT_INFO ci ON ro.CLIENT_ID = ci.CLIENT_ID
    WHERE 
        ro.RowNum <= 6 
    ORDER BY 
        ci.CLIENT_ID, ro.CREATED_AT DESC; 
END;

-- Вызов процедуры
EXEC GetLastSixOrdersForClients; -- всего у первого клиента 7 заказов, тут выводятся последние 6

select * from ORDERS where CLIENT_ID = 1;
select * from CLIENT_INFO; 
select * from ROUTES;

-- 8.  Какой маршрут пользовался наибольшей популярностью для определенного типа автомобилей? Вернуть для всех типов.

select * from VEHICLE;
select * from VEHICLE_TYPE;
select * from ROUTES;
select * from ORDERS;

CREATE OR ALTER PROCEDURE GetMostPopularRoutesByVehicleType
AS
BEGIN
    SET NOCOUNT ON;

    WITH RoutePopularity AS (
        SELECT 
            vt.NAME AS VehicleType,            
            r.START_LOCATION,
            r.END_LOCATION,
            COUNT(o.ID) AS RouteCount
        FROM 
            ORDERS o
        JOIN 
            ROUTES r ON o.ROUTE = r.ID
        JOIN 
            VEHICLE v ON o.DRIVER_ID = v.DRIVER_ID 
        JOIN 
            VEHICLE_TYPE vt ON v.VEHICLE_TYPE = vt.ID  
        GROUP BY 
            vt.NAME, r.START_LOCATION, r.END_LOCATION
    )
    SELECT 
        rp.VehicleType,
        rp.START_LOCATION,
        rp.END_LOCATION,
        rp.RouteCount
    FROM 
        RoutePopularity rp
    JOIN (
        SELECT 
            VehicleType, 
            MAX(RouteCount) AS MaxCount
        FROM 
            RoutePopularity
        GROUP BY 
            VehicleType
    ) AS maxRoutes ON rp.VehicleType = maxRoutes.VehicleType AND rp.RouteCount = maxRoutes.MaxCount
    ORDER BY 
        rp.VehicleType;  
END;

-- Вызов процедуры
EXEC GetMostPopularRoutesByVehicleType;

select * from VEHICLE_TYPE;

select * from ORDERS;

select * from VEHICLE;
update VEHICLE set VEHICLE_TYPE = 10 where id = 10;



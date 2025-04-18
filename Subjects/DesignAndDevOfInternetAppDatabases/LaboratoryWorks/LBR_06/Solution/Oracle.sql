--- 1 Добавить в бд достаточное число правдоподобных данных. Можно генерировать данные и/или использовать импорт. 

INSERT ALL
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, NULL)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, SYSDATE - INTERVAL '30' DAY)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, NULL)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, SYSDATE - INTERVAL '6' MONTH)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, SYSDATE - INTERVAL '1' YEAR)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, NULL)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, SYSDATE - INTERVAL '15' DAY)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, SYSDATE - INTERVAL '90' DAY)
    INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, SYSDATE - INTERVAL '200' DAY)
    -- Добавьте остальные записи аналогично
SELECT * FROM dual;
SELECT * FROM ORDERS; 

SELECT *
FROM ALL_TABLES
WHERE TABLE_NAME = 'ORDERS';


INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES 
(1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -30, GETDATE())); -- 1 месяц назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(MONTH, -6, GETDATE())); -- 6 месяцев назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(YEAR, -1, GETDATE())); -- 1 год назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(DAY, -15, GETDATE())); -- 15 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(DAY, -90, GETDATE())); -- 3 месяца назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(DAY, -200, GETDATE())); -- 200 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, DATEADD(DAY, -45, GETDATE())); -- 45 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -10, GETDATE())); -- 10 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(MONTH, -1, GETDATE())); -- 1 месяц назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(YEAR, -1, GETDATE())); -- 1 год назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, DATEADD(DAY, -60, GETDATE())); -- 2 месяца назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(DAY, -75, GETDATE())); -- 75 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(DAY, -120, GETDATE())); -- 4 месяца назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(MONTH, -8, GETDATE())); -- 8 месяцев назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, DATEADD(DAY, -30, GETDATE())); -- 30 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -200, GETDATE())); -- 200 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, DATEADD(DAY, -15, GETDATE())); -- 15 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(MONTH, -6, GETDATE())); -- 6 месяцев назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(YEAR, -1, GETDATE())); -- 1 год назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, DATEADD(DAY, -30, GETDATE())); -- 30 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(DAY, -90, GETDATE())); -- 90 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(DAY, -45, GETDATE())); -- 45 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(DAY, -10, GETDATE())); -- 10 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL);
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, DATEADD(DAY, -60, GETDATE())); -- 60 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, DATEADD(DAY, -150, GETDATE())); -- 150 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, DATEADD(DAY, -120, GETDATE())); -- 120 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, DATEADD(DAY, -200, GETDATE())); -- 200 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, DATEADD(MONTH, -2, GETDATE())); -- 2 месяца назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, DATEADD(DAY, -180, GETDATE())); -- 180 дней назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, DATEADD(MONTH, -3, GETDATE())); -- 3 месяца назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, DATEADD(MONTH, -4, GETDATE())); -- 4 месяца назад
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES (10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, DATEADD(MONTH, -5, GETDATE())); -- 5 месяцев назад

-- 3 Вычисление итогов предоставленных услуг помесячно, за квартал, за полгода, за год.
CREATE OR REPLACE PROCEDURE CalculateServiceTotals (
    p_StartDate DATE,
    p_EndDate DATE
) AS
    TYPE ServiceAnalysisRec IS RECORD (
        PeriodType NVARCHAR2(20),
        PeriodName NVARCHAR2(30),
        TotalOrders NUMBER,
        TotalWeight NUMBER,
        TotalVolume NUMBER,
        AvgWeight NUMBER,
        AvgVolume NUMBER,
        StartDate DATE,
        EndDate DATE
    );

    TYPE ServiceAnalysisTable IS TABLE OF ServiceAnalysisRec INDEX BY PLS_INTEGER;
    v_ServiceAnalysis ServiceAnalysisTable;
    v_index PLS_INTEGER := 0;

BEGIN
    -- Итоги по месяцам
    FOR rec IN (
        SELECT 
            EXTRACT(YEAR FROM CREATED_AT) AS YearNum,
            EXTRACT(MONTH FROM CREATED_AT) AS MonthNum,
            COUNT(*) AS TotalOrders,
            SUM(BASE_RATE) AS TotalWeight,
            SUM(BASE_RATE) AS TotalVolume,
            AVG(BASE_RATE) AS AvgWeight,
            AVG(BASE_RATE) AS AvgVolume,
            MIN(CREATED_AT) AS StartDate,
            MAX(CREATED_AT) AS EndDate
        FROM 
            SERVICES
        WHERE 
            CREATED_AT BETWEEN p_StartDate AND p_EndDate
        GROUP BY 
            EXTRACT(YEAR FROM CREATED_AT), 
            EXTRACT(MONTH FROM CREATED_AT)
    ) LOOP
        v_index := v_index + 1;
        v_ServiceAnalysis(v_index) := ServiceAnalysisRec(
            'Monthly',
            TO_CHAR(TO_DATE(rec.YearNum || '-' || rec.MonthNum || '-01', 'YYYY-MM-DD'), 'YYYY-MM'),
            rec.TotalOrders,
            rec.TotalWeight,
            rec.TotalVolume,
            rec.AvgWeight,
            rec.AvgVolume,
            rec.StartDate,
            rec.EndDate
        );
    END LOOP;

    -- Итоги за квартал
    FOR rec IN (
        SELECT 
            EXTRACT(YEAR FROM CREATED_AT) AS YearNum,
            CEIL(EXTRACT(MONTH FROM CREATED_AT) / 3) AS QuarterNum,
            COUNT(*) AS TotalOrders,
            SUM(BASE_RATE) AS TotalWeight,
            SUM(BASE_RATE) AS TotalVolume,
            AVG(BASE_RATE) AS AvgWeight,
            AVG(BASE_RATE) AS AvgVolume,
            MIN(CREATED_AT) AS StartDate,
            MAX(CREATED_AT) AS EndDate
        FROM 
            SERVICES
        WHERE 
            CREATED_AT BETWEEN p_StartDate AND p_EndDate
        GROUP BY 
            EXTRACT(YEAR FROM CREATED_AT), 
            CEIL(EXTRACT(MONTH FROM CREATED_AT) / 3)
    ) LOOP
        v_index := v_index + 1;
        v_ServiceAnalysis(v_index) := ServiceAnalysisRec(
            'Quarterly',
            'Q' || rec.QuarterNum || ' ' || rec.YearNum,
            rec.TotalOrders,
            rec.TotalWeight,
            rec.TotalVolume,
            rec.AvgWeight,
            rec.AvgVolume,
            rec.StartDate,
            rec.EndDate
        );
    END LOOP;

    -- Итоги за полгода
    FOR rec IN (
        SELECT 
            EXTRACT(YEAR FROM CREATED_AT) AS YearNum,
            CASE WHEN EXTRACT(MONTH FROM CREATED_AT) BETWEEN 1 AND 6 THEN 1 ELSE 2 END AS HalfYearNum,
            COUNT(*) AS TotalOrders,
            SUM(BASE_RATE) AS TotalWeight,
            SUM(BASE_RATE) AS TotalVolume,
            AVG(BASE_RATE) AS AvgWeight,
            AVG(BASE_RATE) AS AvgVolume,
            MIN(CREATED_AT) AS StartDate,
            MAX(CREATED_AT) AS EndDate
        FROM 
            SERVICES
        WHERE 
            CREATED_AT BETWEEN p_StartDate AND p_EndDate
        GROUP BY 
            EXTRACT(YEAR FROM CREATED_AT), 
            CASE WHEN EXTRACT(MONTH FROM CREATED_AT) BETWEEN 1 AND 6 THEN 1 ELSE 2 END
    ) LOOP
        v_index := v_index + 1;
        v_ServiceAnalysis(v_index) := ServiceAnalysisRec(
            'Half-Year',
            'H' || rec.HalfYearNum || ' ' || rec.YearNum,
            rec.TotalOrders,
            rec.TotalWeight,
            rec.TotalVolume,
            rec.AvgWeight,
            rec.AvgVolume,
            rec.StartDate,
            rec.EndDate
        );
    END LOOP;

    -- Итоги за год
    FOR rec IN (
        SELECT 
            EXTRACT(YEAR FROM CREATED_AT) AS YearNum,
            COUNT(*) AS TotalOrders,
            SUM(BASE_RATE) AS TotalWeight,
            SUM(BASE_RATE) AS TotalVolume,
            AVG(BASE_RATE) AS AvgWeight,
            AVG(BASE_RATE) AS AvgVolume,
            MIN(CREATED_AT) AS StartDate,
            MAX(CREATED_AT) AS EndDate
        FROM 
            SERVICES
        WHERE 
            CREATED_AT BETWEEN p_StartDate AND p_EndDate
        GROUP BY 
            EXTRACT(YEAR FROM CREATED_AT)
    ) LOOP
        v_index := v_index + 1;
        v_ServiceAnalysis(v_index) := ServiceAnalysisRec(
            'Yearly',
            TO_CHAR(rec.YearNum),
            rec.TotalOrders,
            rec.TotalWeight,
            rec.TotalVolume,
            rec.AvgWeight,
            rec.AvgVolume,
            rec.StartDate,
            rec.EndDate
        );
    END LOOP;

    -- Вывод результатов
    FOR i IN 1 .. v_index LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Period Type: ' || v_ServiceAnalysis(i).PeriodType ||
            ', Period Name: ' || v_ServiceAnalysis(i).PeriodName ||
            ', Total Orders: ' || v_ServiceAnalysis(i).TotalOrders ||
            ', Total Weight: ' || v_ServiceAnalysis(i).TotalWeight ||
            ', Total Volume: ' || v_ServiceAnalysis(i).TotalVolume ||
            ', Avg Weight: ' || v_ServiceAnalysis(i).AvgWeight ||
            ', Avg Volume: ' || v_ServiceAnalysis(i).AvgVolume ||
            ', Start Date: ' || v_ServiceAnalysis(i).StartDate ||
            ', End Date: ' || v_ServiceAnalysis(i).EndDate
        );
    END LOOP;
END CalculateServiceTotals;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'CALCULATESERVICETOTALS';

SELECT * 
FROM user_errors 
WHERE name = 'CALCULATESERVICETOTALS' AND type = 'PROCEDURE';

BEGIN
    CalculateServiceTotals(TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));
END;

SELECT * FROM services;

-- 4 Вычисление итогов предоставленных услуг за определенный период:
-- •	объем услуг;
-- •	сравнение их с общим объемом услуг (в %);
-- •	сравнение с максимальным объемом услуг (в %).

CREATE OR REPLACE PROCEDURE CalculateServiceVolumeAnalysis (
    p_StartDate DATE,
    p_EndDate DATE
) AS
    v_PeriodTotalWeight NUMBER;
    v_PeriodTotalVolume NUMBER;
    v_TotalWeight NUMBER;
    v_TotalVolume NUMBER;
    v_MaxWeight NUMBER;
    v_MaxVolume NUMBER;

BEGIN
    -- Итоги за указанный период
    SELECT 
        SUM(CASE 
            WHEN (DELIVERED_AT BETWEEN p_StartDate AND p_EndDate)
                 OR (STATUS IN ('Delivered', 'Completed') AND CREATED_AT BETWEEN p_StartDate AND p_EndDate)
            THEN TOTAL_WEIGHT ELSE 0 END),
        
        SUM(CASE 
            WHEN (DELIVERED_AT BETWEEN p_StartDate AND p_EndDate)
                 OR (STATUS IN ('Delivered', 'Completed') AND CREATED_AT BETWEEN p_StartDate AND p_EndDate)
            THEN TOTAL_VOLUME ELSE 0 END)
    INTO v_PeriodTotalWeight, v_PeriodTotalVolume
    FROM 
        ORDERS;

    -- Общие итоги
    SELECT 
        SUM(TOTAL_WEIGHT),
        SUM(TOTAL_VOLUME)
    INTO 
        v_TotalWeight, v_TotalVolume
    FROM 
        ORDERS
    WHERE 
        STATUS IN ('Delivered', 'Completed');

    -- Максимальные значения
    SELECT 
        MAX(TOTAL_WEIGHT),
        MAX(TOTAL_VOLUME)
    INTO 
        v_MaxWeight, v_MaxVolume
    FROM 
        ORDERS
    WHERE 
        STATUS IN ('Delivered', 'Completed');

    -- Вывод результатов
    DBMS_OUTPUT.PUT_LINE('Period Total Weight: ' || v_PeriodTotalWeight);
    DBMS_OUTPUT.PUT_LINE('Period Total Volume: ' || v_PeriodTotalVolume);

    DBMS_OUTPUT.PUT_LINE('Weight Percentage of Total: ' || 
        CASE WHEN v_TotalWeight > 0 
             THEN ROUND((v_PeriodTotalWeight / v_TotalWeight) * 100, 2) 
             ELSE 0 END);

    DBMS_OUTPUT.PUT_LINE('Volume Percentage of Total: ' || 
        CASE WHEN v_TotalVolume > 0 
             THEN ROUND((v_PeriodTotalVolume / v_TotalVolume) * 100, 2) 
             ELSE 0 END);

    DBMS_OUTPUT.PUT_LINE('Weight Percentage of Max: ' || 
        CASE WHEN v_MaxWeight > 0 
             THEN ROUND((v_PeriodTotalWeight / v_MaxWeight) * 100, 2) 
             ELSE 0 END);

    DBMS_OUTPUT.PUT_LINE('Volume Percentage of Max: ' || 
        CASE WHEN v_MaxVolume > 0 
             THEN ROUND((v_PeriodTotalVolume / v_MaxVolume) * 100, 2) 
             ELSE 0 END);

    DBMS_OUTPUT.PUT_LINE('All Time Total Weight: ' || v_TotalWeight);
    DBMS_OUTPUT.PUT_LINE('All Time Total Volume: ' || v_TotalVolume);
    DBMS_OUTPUT.PUT_LINE('Max Single Order Weight: ' || v_MaxWeight);
    DBMS_OUTPUT.PUT_LINE('Max Single Order Volume: ' || v_MaxVolume);
    DBMS_OUTPUT.PUT_LINE('Analysis Start Date: ' || p_StartDate);
    DBMS_OUTPUT.PUT_LINE('Analysis End Date: ' || p_EndDate);
END CalculateServiceVolumeAnalysis;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'CALCULATESERVICEVOLUMEANALYSIS';

SELECT * 
FROM user_errors 
WHERE name = 'CALCULATESERVICEVOLUMEANALYSIS' AND type = 'PROCEDURE';

BEGIN
    CalculateServiceVolumeAnalysis(TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));
END;

-- 5 Вернуть для каждого клиента направления последних 6 заказов
CREATE OR REPLACE PROCEDURE GET_LAST_ORDERS_FOR_CLIENTS IS
BEGIN
    FOR rec IN (
        SELECT 
            c.ID AS CLIENT_ID,
            o.ROUTE,
            o.CREATED_AT,
            ROW_NUMBER() OVER (PARTITION BY c.ID ORDER BY o.CREATED_AT DESC) AS rn
        FROM 
            CLIENT c
        JOIN 
            ORDERS o ON c.ID = o.CLIENT_ID
    )
    LOOP
        IF rec.rn <= 6 THEN
            DBMS_OUTPUT.PUT_LINE('Client ID: ' || rec.CLIENT_ID || ', Route: ' || rec.ROUTE || ', Created At: ' || rec.CREATED_AT);
        END IF;
    END LOOP;
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'GET_LAST_ORDERS_FOR_CLIENTS';

SELECT * 
FROM user_errors 
WHERE name = 'GET_LAST_ORDERS_FOR_CLIENTS' AND type = 'PROCEDURE';

BEGIN
	GET_LAST_ORDERS_FOR_CLIENTS;
	END;
END

select * from ORDERS where CLIENT_ID =7 ;
SELECT * FROM orders;
select * from CLIENT_INFO; 
SELECT * FROM ROUTES;

-- 6 Какой маршрут пользовался наибольшей популярностью для определенного типа автомобилей? Вернуть для всех типов
CREATE OR REPLACE PROCEDURE GET_POPULAR_ROUTES_BY_VEHICLE_TYPE IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------------------------');
    FOR rec IN (
        SELECT 
            vt.NAME AS VEHICLE_TYPE,
            r.ID AS ROUTE_ID,
            r.START_LOCATION,
            r.END_LOCATION,
            COUNT(o.ID) AS ORDER_COUNT,
            RANK() OVER (PARTITION BY vt.ID ORDER BY COUNT(o.ID) DESC) AS route_rank
        FROM 
            VEHICLE v
        JOIN 
            VEHICLE_TYPE vt ON v.VEHICLE_TYPE = vt.ID
        JOIN 
            ORDERS o ON v.DRIVER_ID = o.DRIVER_ID  
        JOIN 
            ROUTES r ON o.ROUTE = r.ID
        GROUP BY 
            vt.ID, vt.NAME, r.ID, r.START_LOCATION, r.END_LOCATION
    )
    LOOP
        IF rec.route_rank = 1 THEN
            DBMS_OUTPUT.PUT_LINE('Vehicle Type: ' || rec.VEHICLE_TYPE || 
                                 ', Route ID: ' || rec.ROUTE_ID || 
                                 ', Start Location: ' || rec.START_LOCATION || 
                                 ', End Location: ' || rec.END_LOCATION || 
                                 ', Order Count: ' || rec.ORDER_COUNT);
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------------------------');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;

SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = ' GET_POPULAR_ROUTES_BY_VEHICLE_TYPE';

SELECT * 
FROM user_errors 
WHERE name = ' GET_POPULAR_ROUTES_BY_VEHICLE_TYPE' AND type = 'PROCEDURE';

BEGIN
    GET_POPULAR_ROUTES_BY_VEHICLE_TYPE;
END;

SELECT * FROM VEHICLE_TYPE;
SELECT * FROM VEHICLE;
SELECT * FROM ORDERS;
SELECT * FROM ROUTES;

SELECT * FROM VEHICLE;
UPDATE VEHICLE SET VEHICLE_TYPE = 10 WHERE id = 14;
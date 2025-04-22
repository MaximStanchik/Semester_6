-- 1.	Постройте при помощи конструкции MODEL запросы, которые разрабатывают план: 
-- план стоимости перевозок для каждого клиента на следующий год, 
-- учитывая рост стоимости затрат на 10% бензин по сравнению с
-- аналогичным месяцем прошлого года.

WITH monthly_costs AS (
    SELECT 
        c.ID AS client_id,
        ci.FIRST_NAME || ' ' || ci.LAST_NAME AS client_name,
        EXTRACT(YEAR FROM o.DELIVERED_AT) AS year,
        EXTRACT(MONTH FROM o.DELIVERED_AT) AS month,
        SUM(s.BASE_RATE * r.DISTANCE) AS total_cost,
        COUNT(o.ID) AS delivery_count
    FROM 
        ORDERS o
        JOIN CLIENT c ON o.CLIENT_ID = c.ID
        JOIN CLIENT_INFO ci ON c.ID = ci.CLIENT_ID
        JOIN SERVICES s ON o.SERVICE_ID = s.ID
        JOIN ROUTES r ON o.ROUTE = r.ID
    WHERE 
        o.STATUS IN ('Delivered', 'Completed')
        AND o.DELIVERED_AT IS NOT NULL
        AND EXTRACT(YEAR FROM o.DELIVERED_AT) = EXTRACT(YEAR FROM SYSDATE) - 1
    GROUP BY 
        c.ID,
        ci.FIRST_NAME,
        ci.LAST_NAME,
        EXTRACT(YEAR FROM o.DELIVERED_AT),
        EXTRACT(MONTH FROM o.DELIVERED_AT)
)

SELECT 
    client_id,
    client_name,
    year + 1 AS projected_year,
    month,
    current_cost,
    future_cost
FROM monthly_costs
MODEL
    PARTITION BY (client_id, client_name)
    DIMENSION BY (year, month)
    MEASURES (total_cost AS current_cost, 0 AS future_cost)
    RULES (
        future_cost[year + 1, month] = CASE 
                                             WHEN current_cost[CV(year), CV(month)] IS NOT NULL 
                                             THEN current_cost[CV(year), CV(month)] * 1.10 
                                             ELSE 0 
                                         END
    )
ORDER BY 
    client_id, month;
   
-- 2.	Найдите при помощи конструкции MATCH_RECOGNIZE() данные, которые соответствуют шаблону: 
-- Рост, падение, рост предоставления для каждого вида услуг
WITH monthly_costs AS (
    SELECT 
        s.ID AS service_id,
        s.NAME AS service_name,
        EXTRACT(YEAR FROM o.DELIVERED_AT) AS year,
        EXTRACT(MONTH FROM o.DELIVERED_AT) AS month,
        SUM(s.BASE_RATE * r.DISTANCE) AS total_cost,
        LAG(SUM(s.BASE_RATE * r.DISTANCE), 1, NULL) OVER (
            PARTITION BY s.ID 
            ORDER BY EXTRACT(YEAR FROM o.DELIVERED_AT), EXTRACT(MONTH FROM o.DELIVERED_AT)
        ) AS prev_month_cost
    FROM 
        ORDERS o
        JOIN SERVICES s ON o.SERVICE_ID = s.ID
        JOIN ROUTES r ON o.ROUTE = r.ID
    WHERE 
        o.STATUS IN ('Delivered', 'Completed')
        AND o.DELIVERED_AT IS NOT NULL
    GROUP BY 
        s.ID,
        s.NAME,
        EXTRACT(YEAR FROM o.DELIVERED_AT),
        EXTRACT(MONTH FROM o.DELIVERED_AT)
)
SELECT 
    service_id,
    service_name,
    year,
    month,
    total_cost,
    prev_month_cost,
    CASE 
        WHEN prev_month_cost IS NULL THEN 'No previous data'
        WHEN total_cost > prev_month_cost THEN 'Increase'
        WHEN total_cost < prev_month_cost THEN 'Decrease'
        ELSE 'No change'
    END AS cost_change,
    ROUND((total_cost - prev_month_cost) / prev_month_cost * 100, 2) AS change_percentage
FROM 
    monthly_costs
ORDER BY 
    service_id,
    year,
    month;
   
-- Какие есть данные сервисов
WITH monthly_costs AS (
    SELECT 
        s.ID AS service_id,
        EXTRACT(YEAR FROM o.DELIVERED_AT) AS year,
        EXTRACT(MONTH FROM o.DELIVERED_AT) AS month,
        SUM(s.BASE_RATE * r.DISTANCE) AS total_cost
    FROM 
        ORDERS o
        JOIN SERVICES s ON o.SERVICE_ID = s.ID
        JOIN ROUTES r ON o.ROUTE = r.ID
    WHERE 
        o.STATUS IN ('Delivered', 'Completed') 
        AND o.DELIVERED_AT IS NOT NULL
    GROUP BY 
        s.ID,
        EXTRACT(YEAR FROM o.DELIVERED_AT),
        EXTRACT(MONTH FROM o.DELIVERED_AT)
)
SELECT 
    service_id,
    year,
    month,
    total_cost
FROM 
    monthly_costs
ORDER BY 
    service_id, year, month;
   
-- Вставка дополнительных данных в таблицу ORDERS
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (112, 1, 1, 1, 'Delivered', TO_DATE('2025-01-15', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (113, 1, 1, 1, 'Delivered', TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (114, 2, 2, 2, 'Completed', TO_DATE('2025-01-20', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (115, 2, 2, 2, 'Cancelled', TO_DATE('2025-02-25', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (116, 3, 3, 3, 'Delivered', TO_DATE('2025-01-30', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (117, 3, 3, 3, 'Delivered', TO_DATE('2025-02-10', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (118, 4, 4, 4, 'Delivered', TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (119, 4, 4, 4, 'Completed', TO_DATE('2025-02-20', 'YYYY-MM-DD'), 'Same Day');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (120, 5, 5, 5, 'Delivered', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (121, 5, 5, 5, 'Delivered', TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'Standard');
`
-- Вставка дополнительных данных в таблицу ORDERS
-- Вставка дополнительных данных в таблицу ORDERS
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (200, 1, 3, 1, 'Delivered', TO_DATE('2025-04-01', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (201, 1, 3, 1, 'Delivered', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (202, 1, 3, 1, 'Delivered', TO_DATE('2025-06-01', 'YYYY-MM-DD'), 'Same Day');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (203, 2, 4, 2, 'Delivered', TO_DATE('2025-04-01', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (204, 2, 4, 2, 'Delivered', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (205, 2, 4, 2, 'Delivered', TO_DATE('2025-06-01', 'YYYY-MM-DD'), 'Same Day');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (206, 3, 5, 3, 'Delivered', TO_DATE('2025-04-01', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (207, 3, 5, 3, 'Delivered', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (208, 3, 5, 3, 'Delivered', TO_DATE('2025-06-01', 'YYYY-MM-DD'), 'Same Day');

-- Вставка данных в таблицу ORDERS
-- Вставка данных в таблицу ORDERS с учетом DELIVERY_TYPE
-- Вставка дополнительных данных в таблицу ORDERS
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (100, 1, 1, 1, 'Delivered', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (101, 1, 2, 2, 'Completed', TO_DATE('2024-02-10', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (102, 2, 1, 1, 'Delivered', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (103, 2, 3, 3, 'Completed', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Same Day');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (104, 3, 2, 2, 'Delivered', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (105, 3, 3, 3, 'Delivered', TO_DATE('2024-02-20', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (106, 4, 1, 1, 'Delivered', TO_DATE('2024-01-30', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (107, 4, 2, 2, 'Completed', TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'Same Day');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (108, 5, 3, 3, 'Delivered', TO_DATE('2024-01-12', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (109, 6, 1, 1, 'Delivered', TO_DATE('2024-02-18', 'YYYY-MM-DD'), 'Express');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (110, 7, 2, 2, 'Delivered', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'Standard');
INSERT INTO ORDERS (ID, CLIENT_ID, SERVICE_ID, ROUTE, STATUS, DELIVERED_AT, DELIVERY_TYPE) VALUES (111, 8, 3, 3, 'Completed', TO_DATE('2024-02-22', 'YYYY-MM-DD'), 'Same Day');
   
SELECT * FROM CLIENT;
SELECT * FROM CLIENT_INFO; 
SELECT * FROM SERVICES;
SELECT * FROM ROUTES;
SELECT * FROM ORDERS;
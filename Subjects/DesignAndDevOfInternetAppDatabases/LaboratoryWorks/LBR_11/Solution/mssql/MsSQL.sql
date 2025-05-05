-- 1.	Подготовить данные для импорта из БД SQL Server: 
-- создать табличную функцию для отбора необходимых данных 
-- (аргументы – две даты: первая – начало периода выборки, вторая – окончание периода выборки, данные взять из таблиц по варианту).

CREATE FUNCTION dbo.GetOrdersByDateRange
(
    @StartDate DATETIME,
    @EndDate DATETIME
)
RETURNS TABLE
AS
RETURN
(
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
        o.CREATED_AT BETWEEN @StartDate AND @EndDate
);

SELECT * FROM dbo.GetOrdersByDateRange('2025-04-13', '2025-04-16');
select * from ORDERS;

-- 5.	Подготовить данные для импорта из БД Oracle: создать табличную функцию для отбора необходимых данных 
-- (аргументы – две даты: первая – начало периода выборки, вторая – окончание периода выборки, 
-- данные взять из таблиц по варианту, 
-- данные должны содержать числа, строки и даты).

-- 6.	Выгрузить результаты действия функции во внешний файл любым способом (например, SPOOL).

-- 7.	Подготовить данные для экспорта в БД Oracle: подготовить текстовый файл с данными для загрузки в одну из таблиц по варианту.

-- 8.	Загрузить данные из этого файла в базу данных при помощи SQL*Loader, 
-- строки должны быть приведены к виду «Все буквы заглавные», числа округлены до десятых.

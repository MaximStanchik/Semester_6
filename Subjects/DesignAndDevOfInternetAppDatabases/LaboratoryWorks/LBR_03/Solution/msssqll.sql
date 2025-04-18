UPDATE CARGO_TYPE SET HierarchyNode = HIERARCHYID::GetRoot().GetDescendant(NULL, NULL) WHERE id = 1;  -- cleaning services (/)
UPDATE CARGO_TYPE SET HierarchyNode = HIERARCHYID::GetRoot().GetDescendant((SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 1), NULL) WHERE id = 2;  -- home maintenance (/1/)
UPDATE CARGO_TYPE SET HierarchyNode = HIERARCHYID::GetRoot().GetDescendant((SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 2), NULL) WHERE id = 3;  -- car repairs (/2/)

-- Дочерние узлы
UPDATE CARGO_TYPE SET HierarchyNode = (SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 1).GetDescendant(NULL, NULL) WHERE id = 4;  -- deep cleaning (/1/1/)
UPDATE CARGO_TYPE SET HierarchyNode = (SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 2).GetDescendant(NULL, NULL) WHERE id = 5;  -- plumbing (/1/2/1/)
UPDATE CARGO_TYPE SET HierarchyNode = (SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 2).GetDescendant((SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 5), NULL) WHERE id = 6;  -- electrician (/1/2/2/)
UPDATE CARGO_TYPE SET HierarchyNode = (SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 3).GetDescendant(NULL, NULL) WHERE id = 7;  -- oil change (/2/1/)
UPDATE CARGO_TYPE SET HierarchyNode = (SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 3).GetDescendant((SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 7), NULL) WHERE id = 8;  -- brake service (/2/2/)
UPDATE CARGO_TYPE SET HierarchyNode = (SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 2).GetDescendant((SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 6), NULL) WHERE id = 9;  -- hvac repair (/1/2/3/)
UPDATE CARGO_TYPE SET HierarchyNode = (SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 3).GetDescendant((SELECT HierarchyNode FROM CARGO_TYPE WHERE id = 8), NULL) WHERE id = 10;  -- interior detailing (/2/3/)

-- 1. Добавляем столбец иерархического типа
ALTER TABLE CARGO_TYPE 
ADD HierarchyNode HIERARCHYID NULL;

-- Проверяем текущий уровень транзакции
SELECT @@TRANCOUNT AS transaction_level;

select * from cargo_type;
-- Устанавливаем корневой путь для главной категории
UPDATE CARGO_TYPE SET HierarchyNode = HIERARCHYID::GetRoot() WHERE ID = (SELECT MAX(ID) FROM CARGO_TYPE);

-- 2. Процедура для отображения подчиненных узлов
CREATE OR ALTER PROCEDURE GetCargoSubNodes
    @Node HIERARCHYID
AS
BEGIN
    SELECT 
        ID, 
        NAME, 
        DESCRIPTION,
        HierarchyNode.ToString() AS Path, 
        HierarchyNode.GetLevel() AS Level
    FROM CARGO_TYPE
    WHERE HierarchyNode.IsDescendantOf(@Node) = 1
    ORDER BY HierarchyNode;
END;

-- 3. Процедура для добавления подчиненного узла
CREATE OR ALTER PROCEDURE AddCargoSubCategory
    @ParentID INT,
    @CategoryName NVARCHAR(255),
    @Description NVARCHAR(255)
AS
BEGIN
    DECLARE @ParentPath HIERARCHYID;
    DECLARE @NewPath HIERARCHYID;

    -- Получаем путь родителя
    SELECT @ParentPath = HierarchyNode FROM CARGO_TYPE WHERE ID = @ParentID;

    -- Определяем новый путь
    SET @NewPath = @ParentPath.GetDescendant(NULL, NULL);

    -- Вставляем новую запись
    INSERT INTO CARGO_TYPE (NAME, DESCRIPTION, HierarchyNode)
    VALUES (@CategoryName, @Description, @NewPath);
    
    -- Возвращаем ID новой записи
    SELECT SCOPE_IDENTITY() AS NewCategoryID;
END;

-- 4. Процедура для перемещения подчиненных узлов
CREATE OR ALTER PROCEDURE MoveCargoSubordinates
    @OldParentID INT,
    @NewParentID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @OldPath HIERARCHYID;
        DECLARE @NewPath HIERARCHYID;
        
        -- Получаем пути
        SELECT @OldPath = HierarchyNode FROM CARGO_TYPE WHERE ID = @OldParentID;
        SELECT @NewPath = HierarchyNode FROM CARGO_TYPE WHERE ID = @NewParentID;
        
        -- Проверяем, что новый родитель не является потомком старого
        IF @NewPath.IsDescendantOf(@OldPath) = 1
        BEGIN
            THROW 50000, 'Новый родитель не может быть потомком старого', 1;
        END

        -- Проверяем, что старый путь действительно является предком для подчиненных
        IF NOT EXISTS (
            SELECT 1 
            FROM CARGO_TYPE 
            WHERE HierarchyNode.IsDescendantOf(@OldPath) = 1
        )
        BEGIN
            THROW 50001, 'Старый путь не является предком для подчиненных узлов', 1;
        END
        
        -- Обновляем пути всех подчиненных
        UPDATE CARGO_TYPE
        SET HierarchyNode = HierarchyNode.GetReparentedValue(@OldPath, @NewPath)
        WHERE HierarchyNode.IsDescendantOf(@OldPath) = 1 AND ID != @OldParentID;
        
        COMMIT TRANSACTION;

        SELECT COUNT(*) AS MovedNodesCount 
        FROM CARGO_TYPE 
        WHERE HierarchyNode.IsDescendantOf(@NewPath) = 1;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMessage, 1;
    END CATCH
END;
-- Тестирование

-- 1. Вывести подчиненные узлы для категории
BEGIN
    DECLARE @Node HIERARCHYID;
    SET @Node = (SELECT HierarchyNode FROM CARGO_TYPE WHERE ID = 1);
    EXEC GetCargoSubNodes @Node;
END;
SELECT *, HierarchyNode.ToString() AS HierarchyString FROM CARGO_TYPE;

-- 2. Добавить подкатегорию
BEGIN
    BEGIN TRANSACTION;
    EXEC AddCargoSubCategory 
        @ParentID = 1, 
        @CategoryName = 'New Cargo Type', 
        @Description = 'Description of new cargo type';
    EXEC AddCargoSubCategory 
        @ParentID = 1, 
        @CategoryName = 'New Cargo Type', 
        @Description = 'Description of new cargo type';
    EXEC AddCargoSubCategory 
        @ParentID = 1, 
        @CategoryName = 'New Cargo Type', 
        @Description = 'Description of new cargo type';
       EXEC MoveCargoSubordinates @OldParentID = 3, @NewParentID = 1;
    SELECT ID, NAME, DESCRIPTION, HierarchyNode.ToString() AS Path FROM CARGO_TYPE;
    ROLLBACK TRANSACTION;
END;

-- 3. Переместить все подкатегории
BEGIN
    BEGIN TRANSACTION;
    EXEC MoveCargoSubordinates @OldParentID = 3, @NewParentID = 1;
   SELECT ID, NAME, DESCRIPTION, HierarchyNode.ToString() AS Path FROM CARGO_TYPE;
    ROLLBACK TRANSACTION;
END;
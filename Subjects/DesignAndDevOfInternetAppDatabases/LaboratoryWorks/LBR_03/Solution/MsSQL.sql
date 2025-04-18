-- 1. Для базы данных в СУБД SQL Server добавить для одной из таблиц столбец данных иерархического типа. 
select * from CARGO_TYPE;
SELECT *, HierarchyNode.ToString() AS HierarchyString FROM CARGO_TYPE;
UPDATE CARGO_TYPE SET HierarchyNode = NULL;
ALTER TABLE CARGO_TYPE DROP COLUMN HierarchyNode;
DELETE FROM CARGO_TYPE;
delete from CARGO_TYPE where id = 51;

ALTER TABLE CARGO_TYPE ADD HierarchyNode HIERARCHYID;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/') where ID = 1;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/1/') where ID = 2;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/2/') where ID = 3;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/3/') where ID = 4;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/1/1/') where ID = 5;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/1/2/') where ID = 6;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/3/1/') where ID = 7;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/3/2/') where ID = 8;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/3/3/') where ID = 9;

UPDATE CARGO_TYPE
SET HierarchyNode = HIERARCHYID::Parse('/3/4/') where ID = 10;

select * from CARGO_TYPE;

-- 2. Создать процедуру, которая отобразит все подчиненные узлы с указанием уровня иерархии (параметр – значение узла).
CREATE OR ALTER PROCEDURE DisplaySubordinates
    @NodeHierarchy HIERARCHYID
AS
BEGIN
    SELECT *, HierarchyNode.ToString() AS HierarchyPath
    FROM CARGO_TYPE
    WHERE HierarchyNode.IsDescendantOf(@NodeHierarchy) = 1 
    ORDER BY HierarchyNode;
END;

DECLARE @NodeHierarchy HIERARCHYID = '/';
EXEC DisplaySubordinates @NodeHierarchy;

SELECT *, HierarchyNode.ToString() as HierarchyString FROM CARGO_TYPE;

-- 3. Создать процедуру, которая добавит подчиненный узел (параметр – значение родительского узла).

CREATE OR ALTER PROCEDURE add_sub_category
    @parent_id INT,
    @name NVARCHAR(255),
    @description NVARCHAR(255)
AS
BEGIN
    DECLARE @parent_node HIERARCHYID;
    DECLARE @new_node HIERARCHYID;
    DECLARE @exists INT;
    DECLARE @base_node HIERARCHYID;

    -- Get the parent's hierarchy node
    SELECT @parent_node = HierarchyNode FROM CARGO_TYPE WHERE ID = @parent_id;

    -- Start a transaction to ensure uniqueness
    BEGIN TRANSACTION;

    -- Generate the new hierarchy node
    SET @new_node = @parent_node.GetDescendant(NULL, NULL);

    -- Check for uniqueness
    WHILE EXISTS (SELECT 1 FROM CARGO_TYPE WHERE HierarchyNode = @new_node)
    BEGIN
        -- If it exists, get the last child and generate the next sibling
        SET @new_node = @parent_node.GetDescendant(@new_node, NULL);
    END

    -- Insert the new record with the unique hierarchy node
    INSERT INTO CARGO_TYPE (NAME, DESCRIPTION, HierarchyNode)
    VALUES (@name, @description, @new_node);

    COMMIT TRANSACTION;
END;

BEGIN
    EXEC add_sub_category @parent_id = 5, @name = 'New Node', @description = '!!!!!!!!!!';
END;

SELECT *, HierarchyNode.ToString() AS HierarchyString FROM CARGO_TYPE;

delete from CARGO_TYPE where id = 52;

-- 4.  Создать процедуру, которая переместит всех подчиненных (первый параметр – значение родительского узла, 
-- подчиненные которого будут перемещаться, второй параметр – значение нового родительского узла).

CREATE OR ALTER PROCEDURE move_subordinates
    @old_parent_id INT,
    @new_parent_id INT
AS
BEGIN
    DECLARE @old_path HIERARCHYID;
    DECLARE @new_path HIERARCHYID;
    DECLARE @new_sub_path HIERARCHYID;

    -- Получаем пути
    SELECT @old_path = HierarchyNode FROM CARGO_TYPE WHERE ID = @old_parent_id;
    SELECT @new_path = HierarchyNode FROM CARGO_TYPE WHERE ID = @new_parent_id;

    -- Проверка на существование узлов
    IF @old_path IS NULL OR @new_path IS NULL
    BEGIN
        RAISERROR('One of the specified nodes does not exist.', 16, 1);
        RETURN;
    END

    -- Генерируем новый путь для подчиненных
    -- Получаем максимальный дочерний узел нового родителя
    SELECT @new_sub_path = @new_path.GetDescendant(NULL, NULL)
    FROM CARGO_TYPE
    WHERE HierarchyNode.GetAncestor(1) = @new_path;

    -- Отладочная информация
    PRINT 'Old Path: ' + @old_path.ToString();
    PRINT 'New Path: ' + @new_path.ToString();
    PRINT 'New Sub Path: ' + @new_sub_path.ToString();

    -- Обновляем путь всех подчиненных, используя правильные значения
    UPDATE CARGO_TYPE
    SET HierarchyNode = @new_sub_path.GetReparentedValue(HierarchyNode, @old_path)
    WHERE HierarchyNode.IsDescendantOf(@old_path) = 1;

    -- Убедитесь, что перемещение прошло успешно
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No subordinates were moved. Check the hierarchy.', 16, 1);
    END
END;

begin
exec move_subordinates @old_parent_id = 3, @new_parent_id = 1;
SELECT *, HierarchyNode.ToString() AS HierarchyString FROM CARGO_TYPE;
rollback;
end;

SELECT *, HierarchyNode.ToString() AS HierarchyString FROM CARGO_TYPE;

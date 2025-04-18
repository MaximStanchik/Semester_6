-- 1. Для базы данных в СУБД SQL Server добавить для одной из таблиц столбец данных иерархического типа. 
select * from CARGO_TYPE;
delete from CARGO_TYPE where ID = 34;
UPDATE CARGO_TYPE SET HierarchyNode = NULL;

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

SELECT *, HierarchyNode.ToString() as HierarchyString FROM CARGO_TYPE;

-- 2. Создать процедуру, которая отобразит все подчиненные узлы с указанием уровня иерархии (параметр – значение узла).
--drop PROCEDURE DisplaySubordinates

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
-- drop PROCEDURE AddSubordinate

CREATE OR ALTER PROCEDURE AddSubordinate
    @nodeid HIERARCHYID,
    @NewNodeName NVARCHAR(255),
    @NewNodeDescription NVARCHAR(255)
AS
BEGIN
    DECLARE @nextSubordinate HIERARCHYID;
    DECLARE @newSubordinate HIERARCHYID;

    -- Получаем максимальный дочерний узел
    SELECT @nextSubordinate = MAX(HierarchyNode)
    FROM CARGO_TYPE
    WHERE HierarchyNode.GetAncestor(1) = @nodeid;

    -- Определяем новый узел
    IF @nextSubordinate IS NULL
    BEGIN
        SET @newSubordinate = @nodeid.GetDescendant(NULL, NULL);
    END
    ELSE
    BEGIN
        SET @newSubordinate = @nodeid.GetDescendant(@nextSubordinate, NULL);
    END

    IF NOT EXISTS (SELECT 1 FROM CARGO_TYPE WHERE HierarchyNode = @newSubordinate)
    BEGIN
        INSERT INTO CARGO_TYPE (HierarchyNode, NAME, DESCRIPTION)
        VALUES (@newSubordinate, @NewNodeName, @NewNodeDescription);
    END
    ELSE
    BEGIN
        PRINT 'Ошибка: Узел с таким HierarchyNode уже существует.';
    END
END;

DECLARE @ParentNodeHierarchy HIERARCHYID = '/3/4/';
DECLARE @NewNodeName NVARCHAR(255) = 'Cool Stuff !!';
DECLARE @NewNodeDescription NVARCHAR(255) = 'Super staff for cool guys and girls !!!)))';
EXEC AddSubordinate @ParentNodeHierarchy, @NewNodeName, @NewNodeDescription;

SELECT *, HierarchyNode.ToString() AS HierarchyString FROM CARGO_TYPE;

delete from CARGO_TYPE where id = 28; 
select * from CARGO_TYPE;

-- 4.  Создать процедуру, которая переместит всех подчиненных (первый параметр – значение родительского узла, 
-- подчиненные которого будут перемещаться, второй параметр – значение нового родительского узла).

drop procedure MoveSubordinates;
CREATE PROCEDURE MoveSubordinates
@oldParent hierarchyid, @newParent hierarchyid
as
begin
update CARGO_TYPE
set HierarchyNode = HierarchyNode.GetReparentedValue(@oldParent, @newParent)
where HierarchyNode.IsDescendantOf(@oldParent) = 1
end;
SELECT *, HierarchyNode.ToString() as HierarchyString FROM CARGO_TYPE;

DECLARE @oldParent HIERARCHYID = '/3/';
DECLARE @newParent HIERARCHYID = '/1/';
EXEC MoveSubordinates @oldParent, @newParent;

SELECT *, HierarchyNode.ToString() as HierarchyString FROM CARGO_TYPE;
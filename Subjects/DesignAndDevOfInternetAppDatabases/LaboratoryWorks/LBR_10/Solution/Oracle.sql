-- 1.	Создайте отдельное табличное пространство для хранения LOB.
create bigfile tablespace lobTb 
datafile 'log_tb2_dbf' size 100m autoextend on maxsize unlimited;
   
DROP TABLESPACE lobTb;

-- 2.	Создайте отдельную папку для хранения внешних WORD (или PDF) документов.
create directory BFILEDIR as '/BFILE';    
DROP directory BFILEDIR;

SELECT * FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = 'BFILEDIR';
select * from all_directories;
   
-- 3.	Создайте пользователя lob_user с необходимыми привилегиями для вставки, обновления и удаления больших объектов.
-- 4. 	Добавьте квоту на данное табличное пространство пользователю lob_user.

alter session set "_ORACLE_SCRIPT" = true;
ALTER SESSION SET CONTAINER = CDB$ROOT;

SELECT username, con_id
FROM cdb_users
WHERE username = 'lobUser';  

create user lobUser identified by a1111
    default tablespace lobTb
    temporary tablespace temp
    quota unlimited on lobTb
    account unlock;
   
grant connect, resource to lobUser;
grant create session to lobUser;
grant create table to lobUser;
GRANT READ, WRITE ON DIRECTORY BFILE_DIR TO lobUser;

-- 5.	Добавьте в какую-либо таблицу следующие столбцы:
--      – FOTO BLOB: для хранения фотографии;
--      – DOC (или PDF) BFILE: для хранения внешних WORD (или PDF) документов.

CREATE TABLE lob_table (
    id NUMBER PRIMARY KEY
);
ALTER TABLE lob_table ADD (foto BLOB);
ALTER TABLE lob_table ADD (doc BFILE);

drop table lob_table;

SELECT * FROM lob_table;

-- 6. Добавьте (INSERT) фотографии и документы в таблицу.

DECLARE
    v_blob BLOB;
    v_bfile BFILE := BFILENAME('BFILEDIR', 'test.jpg');
    v_file_opened BOOLEAN;
BEGIN
    INSERT INTO lob_table (id, foto, doc) 
    VALUES (1, EMPTY_BLOB(), BFILENAME('BFILEDIR', 'test.docx'))
    RETURNING foto INTO v_blob;

    DBMS_LOB.Open(v_bfile, DBMS_LOB.LOB_READONLY);
    v_file_opened := TRUE;

    DBMS_LOB.LoadFromFile(v_blob, v_bfile, DBMS_LOB.getlength(v_bfile));
    COMMIT;
    
    IF v_file_opened THEN
        DBMS_LOB.Close(v_bfile);
    END IF;
END;

select * from lob_table;
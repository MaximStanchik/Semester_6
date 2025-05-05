-- 1.	Создайте отдельное табличное пространство для хранения LOB.
create bigfile tablespace lobTb 
datafile 'log_tb2_dbf' size 100m autoextend on maxsize unlimited;
   
DROP TABLESPACE lobTb;

-- 2.	Создайте отдельную папку для хранения внешних WORD (или PDF) документов.
create OR REPLACE directory bfile_dir as '/BFILE';
   
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
create directory BFILEDIR as '/BFILE';    
DROP directory BFILEDIR;


INSERT INTO lob_table VALUES (2, NULL, BFILENAME('BFILEDIR', 'test.jpg'));


INSERT INTO lob_table (id, foto, doc) VALUES (1, EMPTY_BLOB(), BFILENAME('BFILEDIR', 'test.docx'));
DELETE FROM lob_table;

DECLARE
  SRC_FILE BFILE;
  DST_FILE BLOB;
  LGH_FILE BINARY_INTEGER;
BEGIN
  SRC_FILE := BFILENAME('BFILEDIR', 'TEST.JPG');

  -- Вставка с возвратом дескриптора
  INSERT INTO lob_table (id, foto, doc)
  VALUES (3, EMPTY_BLOB(), NULL)
  RETURNING foto INTO DST_FILE;

  -- Открыть и загрузить содержимое
  DBMS_LOB.FILEOPEN(SRC_FILE, DBMS_LOB.FILE_READONLY);
  LGH_FILE := DBMS_LOB.GETLENGTH(SRC_FILE);
  DBMS_LOB.LOADFROMFILE(DST_FILE, SRC_FILE, LGH_FILE);
  DBMS_LOB.FILECLOSE(SRC_FILE);

  COMMIT;
END;

SELECT * FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = 'BFILEDIR';
select * from lob_table;
select * from all_directories;
-- 1.	Создайте отдельное табличное пространство для хранения LOB.
create bigfile tablespace lobTb 
datafile 'log_tb2_dbf' size 100m autoextend on maxsize unlimited;
   
DROP TABLESPACE lobTb;

-- 2.	Создайте отдельную папку для хранения внешних WORD (или PDF) документов.
create OR REPLACE directory bfile_dir as 'C:/BFILE';    
   
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

-- 6. Добавьте (INSERT) фотографии и документы в таблицу.
create directory bfile_dir as 'D:/User/Documents/GitHub/Semester_6/Subjects/DesignAndDevOfInternetAppDatabases/LaboratoryWorks/LBR_10/Solution/word_documents';       
INSERT INTO lob_table (id, foto, doc) VALUES (1, EMPTY_BLOB(), BFILENAME('bfile_dir', 'test.docx'));
DELETE FROM lob_table;
DECLARE
    v_src_file BFILE;
    v_dst_file BLOB;
    v_lgh_file INTEGER;
BEGIN
    v_src_file := BFILENAME('BFILE_DIR', 'test.jpg');

    SELECT foto INTO v_dst_file
    FROM lob_table
    WHERE id = 1
    FOR UPDATE;

    DBMS_LOB.FILEOPEN(v_src_file, DBMS_LOB.FILE_READONLY);

    v_lgh_file := DBMS_LOB.GETLENGTH(v_src_file);

    DBMS_LOB.LOADFROMFILE(v_dst_file, v_src_file, v_lgh_file);

    DBMS_LOB.FILECLOSE(v_src_file);
END;

SELECT * FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = 'BFILE_DIR';
SELECT * FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = 'BFILE_DIR';

select * from lob_table;
select * from all_directories;

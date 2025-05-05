create tablespace lob_data
    datafile 'log.tb.dbf'
    size 1000m
    autoextend on next 100m;
   
-- 2. Создайте отдельную папку для хранения внешних WORD (или PDF) документов.
-- Папка C:/BFILE

-- 3. Создайте пользователя lob_user с необходимыми привилегиями 
-- для вставки, обновления и удаления больших объектов.
   
alter session set "_ORACLE_SCRIPT" = true;
ALTER SESSION SET CONTAINER = CDB$ROOT;
   
create user lobUser identified by a1111
default tablespace lob_data
temporary tablespace temp
quota 100M on lob_data
account unlock;
   
GRANT CONNECT, RESOURCE TO lobUser;
GRANT CREATE ANY DIRECTORY TO lobUser;
GRANT CREATE SESSION TO lobUser;
GRANT CREATE TABLE TO lobUser;
GRANT DROP ANY DIRECTORY TO lobUser;
GRANT EXECUTE ON DBMS_LOB TO lobUser;

-- 4. Добавьте квоту на данное табличное пространство пользователю lob_user.
ALTER USER lobUser QUOTA 100M ON lob_data;


-- 5. Добавьте в какую-либо таблицу следующие столбцы:
-- FOTO BLOB: для хранения фотографии;
-- DOC (или PDF) BFILE: для хранения внешних WORD (или PDF) документов.
CREATE TABLE lob_table (
    id NUMBER PRIMARY KEY
);

ALTER TABLE lob_table ADD (foto BLOB);
ALTER TABLE lob_table ADD (doc BFILE);

drop table lob_table;

-- 6. Добавьте (INSERT) фотографии и документы в таблицу.
CREATE DIRECTORY HOME AS '/BFILE';
INSERT INTO lob_table (id, foto, doc) VALUES (10, BFILENAME('HOME', 'test.jpg'), BFILENAME('HOME', 'test.docx'));

select * from lob_table;
select * from all_directories;
create tablespace lobTb
    datafile 'log.tb2.dbf'
    size 1000m
    autoextend on next 100m;

create user lobUser identified by 123123123
    default tablespace lobTb
    temporary tablespace temp
    quota unlimited on lob_tb
    account unlock;

grant connect, resource to lobUser;
grant create session to lobUser;
grant create table to lobUser;

create table lob_table
(
    foto blob,
    doc bfile
)

CREATE TABLE LOBLOB
(
  IDLOB NUMBER(5) PRIMARY KEY,
  BBB BLOB,
  FFF BFILE
);

SELECT * FROM LOBLOB;
DELETE FROM LOBLOB where IDLOB > 0;
CREATE OR REPLACE DIRECTORY bfile_dir AS '/BFILE';
CREATE OR REPLACE DIRECTORY LOBDIR AS '/BFILE';

INSERT INTO LOBLOB VALUES (4, NULL, BFILENAME('LOBDIR', '1.JPG'));

DECLARE
  SRC_FILE BFILE;
  DST_FILE BLOB;
  LGH_FILE BINARY_INTEGER;
BEGIN
  SRC_FILE := BFILENAME('LOBDIR', '1.JPG');

  INSERT INTO LOBLOB VALUES (2, EMPTY_BLOB(), NULL) RETURNING BBB INTO DST_FILE;

  SELECT BBB INTO DST_FILE FROM LOBLOB WHERE IDLOB = 2 FOR UPDATE;

  DBMS_LOB.OPEN(SRC_FILE , DBMS_LOB.LOB_READONLY);
  LGH_FILE := DBMS_LOB.GETLENGTH(SRC_FILE);
  DBMS_LOB.LOADFROMFILE(DST_FILE, SRC_FILE, LGH_FILE);
  DBMS_LOB.CLOSE(SRC_FILE);

  UPDATE LOBLOB SET BBB = DST_FILE WHERE IDLOB = 3;
  COMMIT;
END;

SELECT * FROM LOBLOB;
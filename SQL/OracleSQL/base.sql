-- OracleSQL base commands --

-- Empty recyclebin --
-- Free a LOT of space (this operation with sysdba grant will empty EVERY recyclebin) --
purge recyclebin;

-- Reclaim unused space from table --
-- Useful to reclaim some space after a delete or truncate --
-- Param $1: table name --
alter table $1 enable row movement;
alter table $1 deallocate unused;
alter table $1 shrink space cascade;
alter table $1 disable row movement;

-- Reclaim unused space from lob --
-- Useful to reclaim some space after a delete or truncate --
-- Param $1: table name --
-- Param $2: colum name of table with type lob --
alter table $1 modify lob ($2) (shrink space);

-- Get which table lob belong --
-- Param $1: lob name (ex. SYS_LOB****$$) --
select owner, table_name, column_name from dba_lobs where segment_name = '$1';

-- Get list of lobs belong to table --
-- Param $1: table name --
select table_name, column_name from dba_lobs where segment_name = '$1';

-- Tablespace defragmentation --
-- Read / write performace boost --
alter tablespace TS coalesce;

-- Keep only last 48 hour of audit trail --
-- Use for quickly free some space in SYSAUX --
exec DBMS_AUDIT_MGMT.INIT_CLEANUP(audit_trail_type=> DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, default_cleanup_interval=>48);

-- Get last 3 data block at the end of the datafile --
-- Useful when you can't resize because some data are beyon resize values --
-- Param $1: datafile path (ex. /u01/app/oracle/oradata/DEV/data.dbf) --
select *  from (select owner, segment_name, segment_type, block_id from dba_extents where file_id = ( select file_id from dba_data_files where file_name = '$1' ) order by block_id desc ) where rownum <= 3;

-- Get datafile file_id list --
select distinct tablespace_name, file_id from dba_extents;

-- Get a list of all table in given tablespace with used space in MB --
-- Param $1: tablespace name --
col Mb form 9,999,999
col SEGMENT_NAME form a40
col SEGMENT_TYPE form a6
set lines 120
select sum(bytes/1024/1024) Mb, segment_name,segment_type from dba_segments where  tablespace_name = '$1' and segment_type='TABLE' group by segment_name,segment_type order by 1 asc;

-- Get the hight block of tablespace --
-- Param $1: tablespace name --
select max(block_id+blocks)*8192/1024/1024 high_mb from dba_extents where tablespace_name = 'TB';

-- Get biggest file_id segment file
-- Param $1: file id (see "Get datafile file_id list") --
select segment_name from dba_extents where file_id=1 and ((block_id + blocks-1)*8192) > 104857600;

-- Get the biggest segment size of tablespace --
-- Param $1: tablespace name --
select max(bytes/1024/1024) from dba_segments where tablespace_name = '$1';

-- Snapshot info --
select min(snap_id),MAX(snap_id) from wrh$_active_session_history;
select min(snap_id),MAX(snap_id) from wrh$_event_histogram;
select min(snap_id),MAX(snap_id) from wrh$_sql_bind_metadata;

-- Remove snapshots --
-- Param $1 low snapshot id --
-- Param $2 hight snapshot id --
exec DBMS_WORKLOAD_REPOSITORY.DROP_SNAPSHOT_RANGE($1,$2);

-- Purge AWR SQL --
-- Use for quickly free some space in SYSAUX --
-- Tip: shrink tables to gain more space
truncate table wrh$_sqlstat;
truncate table wrh$_sqltext;
truncate table wrh$_sql_plan;
-- Shrink after purge --
alter table wrh$_sqlstat enable row movement;
alter table wrh$_sqltext enable row movement;
alter table wrh$_sql_plan enable row movement;
alter table wrh$_event_histogram enable row movement;
alter table wrh$_sql_bind_metadata enable row movement;
alter table wrh$_symetric_history enable row movement;
alter table wrh$_sqlstat shrink space cascade;
alter table wrh$_sqltext shrink space cascade;
alter table wrh$_sql_plan shrink space cascade;
alter table wrh$_event_histogram shrink space cascade;
alter table wrh$_sql_bind_metadata shrink space cascade;
alter table wrh$_symetric_history space cascade;
alter table wrh$_sqlstat disable row movement;
alter table wrh$_sqltext disable row movement;
alter table wrh$_sql_plan disable row movement;
alter table wrh$_event_histogram disable row movement;
alter table wrh$_sql_bind_metadata disable row movement;
alter table wrh$_symetric_history disable row movement;

-- Get DB ID --
select distinct dbid from dba_hist_snapshot;

-- ??? ---
-- Param $1 ??? --
-- Param $2 DB id (see "Get DB ID") --
exec dbms_workload_repository.purge_sql_details(1000, $2);  

-- Purge old stats (maintain only 3 days) --
-- Use for quickly free some space in SYSAUX --
exec DBMS_STATS.PURGE_STATS(SYSDATE-3);

-- Drop baseline --
-- Param $1 balseline name (ex. SYSTEM_MOVING_WINDOW) --
-- Param $2 DB id (see "Get DB ID") --
execute DBMS_WORKLOAD_REPOSITORY.DROP_BASELINE ( baseline_name => '$1',cascade=>true,dbid=>$2);

-- Memory --
alter system set memory_max_target=20G;
shutdown immediate
startup
alter system set memory_target=17G;

-- Unlock user --
alter user username account unlock

-- Disable password expiration --
select profile from DBA_USERS where username = username;
alter profile profile limi password_life_time UNLIMITED;

-- Create tablespace --
CREATE TABLESPACE ts DATAFILE 'ts.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE 2G;

-- Create user --
CREATE USER username IDENTIFIED BY password DEFAULT TABLESPACE ts TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON ts;
ALTER USER username QUOTA UNLIMITED ON other_ts;

-- Roles --
CREATE ROLE ts_data_inquiry IDENTIFIED BY ts_data_inquiry;
CREATE ROLE ts_data_manipulation IDENTIFIED BY ts_data_manipulation;
GRANT resource, connect, imp_full_database, ts_data_inquiry,  ts_data_manipulation TO username;

-- User remove --
drop user username cascade;

-- Tablespace remove --
drop ts including contents and datafiles cascade constraints;

-- Directory --
-- Param $1 direcotry name --
CREATE DIRECTORY $1 AS 'absolute_physical_path_on_server';
SELECT * FROM ALL_DIRECTORIES;
grant read,write on directory $1 to username
grant read,write on directory IMPORTDIR to public

-- Running queries
select s.sid, s.serial#, p.spid, s.username, s.schemaname
     , s.program, s.terminal, s.osuser
  from v$session s
  join v$process p
    on s.paddr = p.addr
 where s.type != 'BACKGROUND'
 
 -- Erase the world
 SET SERVEROUTPUT ON SIZE 1000000
BEGIN
  FOR cur_rec IN (SELECT object_name, object_type 
                  FROM   user_objects
                  WHERE  object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE')) LOOP
    BEGIN
      IF cur_rec.object_type = 'TABLE' THEN
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
      ELSE
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('FAILED: DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"');
    END;
  END LOOP;
END;
/
                                         
-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/ts_free_space.sql
-- Author       : Tim Hall
-- Description  : Displays a list of tablespaces and their used/full status.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @ts_free_space.sql
-- Last Modified: 13-OCT-2012 - Created. Based on ts_full.sql
-- -----------------------------------------------------------------------------------
SET PAGESIZE 140
COLUMN used_pct FORMAT A11

SELECT tablespace_name,
       size_mb,
       free_mb,
       max_size_mb,
       max_free_mb,
       TRUNC((max_free_mb/max_size_mb) * 100) AS free_pct,
       RPAD(' '|| RPAD('X',ROUND((max_size_mb-max_free_mb)/max_size_mb*10,0), 'X'),11,'-') AS used_pct
FROM   (
        SELECT a.tablespace_name,
               b.size_mb,
               a.free_mb,
               b.max_size_mb,
               a.free_mb + (b.max_size_mb - b.size_mb) AS max_free_mb
        FROM   (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024) AS free_mb
                FROM   dba_free_space
                GROUP BY tablespace_name) a,
               (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024) AS size_mb,
                       TRUNC(SUM(GREATEST(bytes,maxbytes))/1024/1024) AS max_size_mb
                FROM   dba_data_files
                GROUP BY tablespace_name) b
        WHERE  a.tablespace_name = b.tablespace_name
       )
ORDER BY tablespace_name;

SET PAGESIZE 14

-- Tables that may benefit from a rebuild --
-- total space usage up to the  HWM is 10
   LOOP
      DBMS_OUTPUT.put_line (   'Candidate table is '
                            || space_usage.owner
                            || '.'
                            || space_usage.table_name
                           );
      DBMS_OUTPUT.put_line (   'Which is using  '
                            || space_usage.space_full
                            || '% of allocated space. '
                           );
      DBMS_OUTPUT.put_line (   'Which is using  '
                            || space_usage.hwm_full
                            || '% of allocated space to the HWM. '
                           );
      DBMS_OUTPUT.put_line ('You can use this script to compact the table:');
      DBMS_OUTPUT.put_line (   'alter table '
                            || space_usage.owner
                            || '.'
                            || space_usage.table_name
                            || ' enable row movement; '
                           );
      DBMS_OUTPUT.put_line (   'alter table '
                            || space_usage.owner
                            || '.'
                            || space_usage.table_name
                            || ' shrink space cascade; '
                           );
      DBMS_OUTPUT.put_line (CHR (13));
   END LOOP;
END;
/
                                 
--Calcualte SCHEMA SIZE   
SELECT
   owner, table_name, round(sum(bytes)/1024/1024, 2) Mb
FROM
(
SELECT segment_name table_name, owner, bytes
 FROM dba_segments
 WHERE segment_type = 'TABLE'

 UNION ALL
 SELECT i.table_name, i.owner, s.bytes
 FROM dba_indexes i, dba_segments s
 WHERE s.segment_name = i.index_name
 AND   s.owner = i.owner
 AND   s.segment_type = 'INDEX'

 UNION ALL
 SELECT l.table_name, l.owner, s.bytes
 FROM dba_lobs l, dba_segments s
 WHERE s.segment_name = l.segment_name
 AND   s.owner = l.owner
 AND   s.segment_type = 'LOBSEGMENT'

 UNION ALL
 SELECT l.table_name, l.owner, s.bytes
 FROM dba_lobs l, dba_segments s
 WHERE s.segment_name = l.index_name
 AND   s.owner = l.owner
 AND   s.segment_type = 'LOBINDEX'
 )
WHERE owner = 'DDCOM'
GROUP BY table_name, owner
--HAVING SUM(bytes)/1024/1024 > 10  /* Ignore really small tables */
ORDER BY SUM(bytes) desc
;

---Commander Occupacy
SELECT  SUM(Mb) AS TOTAL FROM
(
SELECT
   owner, table_name, round(sum(bytes)/1024/1024, 2) Mb
FROM
(SELECT segment_name table_name, owner, bytes
 FROM dba_segments
 WHERE segment_type = 'TABLE'
 /*
 UNION ALL
 SELECT i.table_name, i.owner, s.bytes
 FROM dba_indexes i, dba_segments s
 WHERE s.segment_name = i.index_name
 AND   s.owner = i.owner
 AND   s.segment_type = 'INDEX'
 /*
 UNION ALL
 SELECT l.table_name, l.owner, s.bytes
 FROM dba_lobs l, dba_segments s
 WHERE s.segment_name = l.segment_name
 AND   s.owner = l.owner
 AND   s.segment_type = 'LOBSEGMENT'
 UNION ALL
 SELECT l.table_name, l.owner, s.bytes
 FROM dba_lobs l, dba_segments s
 WHERE s.segment_name = l.index_name
 AND   s.owner = l.owner
 AND   s.segment_type = 'LOBINDEX'
 */
 )
WHERE owner = 'DDCOM'
AND table_name LIKE 'DD_COM_%'
GROUP BY table_name, owner
--HAVING SUM(bytes)/1024/1024 > 10  /* Ignore really small tables */
ORDER BY SUM(bytes) desc
)
;

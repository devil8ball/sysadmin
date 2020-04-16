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

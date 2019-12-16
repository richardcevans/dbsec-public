#!/bin/bash

sqlplus -s / as sysdba <<EOF
-- 
set lines 90
set pages 999
BREAK ON PDB_NAME SKIP PAGE ON PDB_NAME
column pdb_name format a20
column name format a25
column status format a20
column open_mode format a20
select * from dba_dv_status;
-- 
select a.name pdb_name, a.open_mode, b.name, b.status 
  from v\$pdbs a, cdb_dv_status b
 where a.con_id = b.con_id
 order by 1,2;
--
EOF

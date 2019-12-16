#!/bin/bash

sqlplus -s /nolog <<EOF
--
connect c##dvowner/Oracle123+@crmprod
--
set lines 110
set pages 9999
column VIOLATION_TYPE format a29
column username format a15
column machine format a22
column command format a12
column dv\$_module format a12
column sqltext format a60
SELECT VIOLATION_TYPE, USERNAME, MACHINE, COMMAND, DV\$_MODULE, SQLTEXT FROM DBA_DV_SIMULATION_LOG;
--
EOF

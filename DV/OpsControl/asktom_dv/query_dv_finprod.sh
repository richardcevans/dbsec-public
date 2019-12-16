#!/bin/bash

sqlplus -s /nolog <<EOF
--
set lines 90
--
connect c##sec_dba_sal/Oracle123+
--
alter session set container=finprod;
show user
show con_name
select * from dba_dv_status;
select count(*) from hr.employees;
--
EOF

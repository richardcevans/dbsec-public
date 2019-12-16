#!/bin/bash

sqlplus -s /nolog <<EOF
--
set lines 90
--
connect c##sec_dba_sal/Oracle123+@hrprod
show user
show con_name
select count(*) from hr.employees;
--
connect c##sec_dba_sal/Oracle123+@finprod
show user
show con_name
select count(*) from hr.employees;
--
connect c##sec_dba_sal/Oracle123+@crmprod
show user
show con_name
select count(*) from hr.employees;
EOF

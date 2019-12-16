#!/bin/bash

sqlplus -s /nolog <<EOF
--
set lines 90
--
connect c##dba_debra/Oracle123+@hrprod
show user
show con_name
select count(*) from hr.employees;
--
connect c##dba_debra/Oracle123+@finprod
show user
show con_name
select count(*) from hr.employees;
--
connect c##dba_debra/Oracle123+@crmprod
show user
show con_name
select count(*) from hr.employees;
EOF

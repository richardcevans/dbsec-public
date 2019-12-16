#!/bin/bash

sqlplus -s /nolog <<EOF
--
connect c##dvowner/Oracle123+@crmprod
select count(*) from dba_dv_simulation_log;
DELETE FROM DVSYS.SIMULATION_LOG$;
select count(*) from dba_dv_simulation_log;
--
EOF

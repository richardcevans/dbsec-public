#!/bin/bash

sqlplus -s /nolog <<EOF
--
set lines 90
--
connect c##dvowner/Oracle123+
desc DBA_DV_APP_EXCEPTION;
select * from DBA_DV_APP_EXCEPTION;
--
EXEC DBMS_MACADM.ADD_APP_EXCEPTION('C##sec_dba_sal','%');
--
select * from DBA_DV_APP_EXCEPTION;
EOF

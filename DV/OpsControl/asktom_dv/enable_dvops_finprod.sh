#!/bin/bash

sqlplus -s /nolog <<EOF
--
set lines 90
--
connect c##dvowner/Oracle123+
EXEC DBMS_MACADM.ENABLE_APP_PROTECTION('FINPROD');
--
EOF

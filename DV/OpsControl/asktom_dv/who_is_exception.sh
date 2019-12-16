#!/bin/bash

sqlplus -s /nolog <<EOF
--
connect c##dvowner/Oracle123+
select * from DBA_DV_APP_EXCEPTION;
--
EOF

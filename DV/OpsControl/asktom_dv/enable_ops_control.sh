#!/bin/bash

sqlplus -s /nolog <<EOF
--
set lines 90
--
connect c##dvowner/Oracle123+
exec dbms_macadm.enable_app_protection;
--
EOF

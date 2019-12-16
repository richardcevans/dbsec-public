#!/bin/bash

sqlplus -s /nolog <<EOF
--
connect c##dvowner/Oracle123+@crmprod
BEGIN
DBMS_MACADM.CREATE_CONNECT_COMMAND_RULE(
 rule_set_name   => 'Disabled', 
 user_name       => 'HR', 
 enabled         => DBMS_MACUTL.G_SIMULATION);
END; 
/
--
EOF

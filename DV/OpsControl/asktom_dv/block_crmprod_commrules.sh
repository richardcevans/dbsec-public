#!/bin/bash

sqlplus -s /nolog <<EOF
connect c##dvowner/Oracle123+@crmprod
--
begin
 DBMS_MACADM.UPDATE_COMMAND_RULE(
 command         => 'SELECT', 
 rule_set_name   => 'RS_ALLOW_HR_ACCESS', 
 object_owner    => 'HR', 
 object_name     => 'EMPLOYEES', 
 enabled         => DBMS_MACUTL.G_YES);
end;
/
EOF

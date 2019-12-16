#!/bin/bash

sqlplus -s /nolog <<EOF
connect c##dvowner/Oracle123+@crmprod
--
begin 
 DVSYS.DBMS_MACADM.CREATE_RULE(
  rule_name => 'ALLOW_HR_ACCESS'
, rule_expr => 'SYS_CONTEXT(''USERENV'',''SESSION_USER'') = ''HR'''); 
end;
/
--
begin
 DVSYS.DBMS_MACADM.CREATE_RULE_SET(
 rule_set_name => 'RS_ALLOW_HR_ACCESS'
, description => 'This Rule Set Limits SELECT access'
, enabled => 'Y'
, eval_options => 2
, audit_options => 1
, fail_options => 1
, fail_message => 'Only HR can use SELECT'
, fail_code => '-20001'
, handler_options => 0
, handler => ''
,is_static => TRUE); 
end;
/
--
BEGIN
 DVSYS.DBMS_MACADM.ADD_RULE_TO_RULE_SET(
  rule_set_name => 'RS_ALLOW_HR_ACCESS'
, rule_name => 'ALLOW_HR_ACCESS'
, rule_order => '1'
, enabled => 'Y');
END;
/
--
begin
 DBMS_MACADM.UPDATE_COMMAND_RULE(
 command         => 'SELECT', 
 rule_set_name   => 'RS_ALLOW_HR_ACCESS', 
 object_owner    => 'HR', 
 object_name     => 'EMPLOYEES', 
 enabled         => DBMS_MACUTL.G_SIMULATION);
end;
/
EOF

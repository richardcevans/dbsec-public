. /vagrant_config/install.env

# for use with tim hall's vagrant scripts
# located here: https://github.com/oraclebase/vagrant

echo "******************************************************************************"
echo "Source the Oracle Enviroment variables." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh


## oracle_configure_dv.sh

$ORACLE_HOME/bin/sqlplus / as sysdba <<EOF

set lines 140
set pages 9999

startup;
alter pluggable database pdb1 open;

create user C##DVOWNER identified by "Oracle123+" container=all;
create user C##DVACCTMGR identified by "Oracle123+" container=all;

create user C##DVOWNER_BACKUP identified by "Oracle123+" container=all;
create user C##DVACCTMGR_BACKUP identified by "Oracle123+" container=all;

grant connect, resource to C##DVOWNER container=all;
grant connect, resource to C##DVOWNER_BACKUP container=all;

grant connect, resource to C##DVACCTMGR container=all;
grant connect, resource to C##DVACCTMGR_BACKUP container=all;

show con_name;
select * from dba_dv_status;

-- configure DV on the CDB
BEGIN
 DVSYS.CONFIGURE_DV (
   dvowner_uname         => 'C##DVOWNER',
   dvacctmgr_uname       => 'C##DVACCTMGR');
 END;
/

-- make sure we have the proper roles for our backup accounts
grant dv_acctmgr to C##DVACCTMGR_BACKUP container=all;
grant dv_owner to C##DVOWNER_BACKUP container=all;

-- Enable DV on the CDB
connect c##dvowner/"Oracle123+"
show user;
show con_name;

EXEC DBMS_MACADM.ENABLE_DV;

-- configure DV on the PDB1
connect / as sysdba

shutdown immediate;

startup;
alter pluggable database pdb1 open;
show pdbs;

connect c##dvowner/"Oracle123+"
exec dbms_macadm.enable_app_protection;

connect / as sysdba
select * from dba_dv_status;

alter session set container=pdb1;
show con_name;
select * from dba_dv_status;

BEGIN
 DVSYS.CONFIGURE_DV (
   dvowner_uname         => 'C##DVOWNER',
   dvacctmgr_uname       => 'C##DVACCTMGR');
 END;
/

-- Enable DV on the PDB1
connect c##dvowner/"Oracle123+"@pdb1
show user;
show con_name;

EXEC DBMS_MACADM.ENABLE_DV;

-- Restart the PDB and CDB
connect / as sysdba

alter pluggable database pdb1 close immediate;
alter pluggable database pdb1 open;

-- Verify DV is configured and enabled on the CDB
connect / as sysdba
show user;
show con_name;
select * from dba_dv_status;

-- Verify DV is configured and enabled on the PDB
connect / as sysdba
alter session set container=pdb1;
show user;
show con_name;
select * from dba_dv_status;

EOF

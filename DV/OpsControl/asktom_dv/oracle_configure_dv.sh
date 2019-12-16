. /vagrant_config/install.env

echo "******************************************************************************"
echo "Source the Oracle Enviroment variables." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh


## oracle_configure_dv.sh

$ORACLE_HOME/bin/sqlplus -s / as sysdba <<EOF

set lines 140
set pages 9999

startup;
alter pluggable database all open;

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

-- Enable DV on the CDB
connect c##dvowner/"Oracle123+"
show user;
show con_name;

EXEC DBMS_MACADM.ENABLE_DV;

grant DV_OWNER to C##DVOWNER_BACKUP container=all;

connect c##dvacctmgr/"Oracle123+"
show user

grant DV_ACCTMGR to C##DVACCTMGR_BACKUP container=all;

-- configure DV on the PDB
connect / as sysdba

shutdown immediate;

startup;
alter pluggable database all open;
show pdbs;

connect / as sysdba
select * from dba_dv_status;

alter session set container=crmprod;
show con_name;
select * from dba_dv_status;

BEGIN
 DVSYS.CONFIGURE_DV (
   dvowner_uname         => 'C##DVOWNER',
   dvacctmgr_uname       => 'C##DVACCTMGR');
 END;
/


-- Enable DV on the PDB
connect c##dvowner/"Oracle123+"@crmprod
show user;
show con_name;

EXEC DBMS_MACADM.ENABLE_DV;

-- Restart the PDB
connect / as sysdba

alter pluggable database all close immediate;
alter pluggable database all open;
show pdbs;

-- Verify DV is configured and enabled on the CDB
connect / as sysdba
show user;
show con_name;
select * from dba_dv_status;


-- Verify DV is configured and enabled on the PDB
connect / as sysdba
alter session set container=crmprod;
show user;
show con_name;
select * from dba_dv_status;

EOF

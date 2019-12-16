. /vagrant_config/install.env

# for use with tim hall's vagrant scripts
# located here: https://github.com/oraclebase/vagrant

echo "******************************************************************************"
echo "Source the Oracle Enviroment variables." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh

# create our wallet directories

export TDE_WALLET_DIR=${ORACLE_BASE}/admin/${ORACLE_SID}/wallet
export TDE_SEPS_DIR=${ORACLE_BASE}/admin/${ORACLE_SID}/wallet/tde_seps

mkdir -p ${ORACLE_BASE}/admin/${ORACLE_SID}/wallet/tde_seps
find ${ORACLE_BASE}/admin/${ORACLE_SID}

# What are the minimum commands required to use the EXTERNAL STORE capability?

sqlplus / as sysdba <<EOF
set lines 140
set pages 9999

column wrl_parameter format a55
column status format a25

select con_id, wrl_parameter, status from v\$encryption_wallet where con_id = 1;

ALTER SYSTEM SET WALLET_ROOT='${TDE_WALLET_DIR}' scope=spfile;
SHUTDOWN IMMEDIATE;
STARTUP;

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;

ADMINISTER KEY MANAGEMENT CREATE KEYSTORE IDENTIFIED BY Oracle123;

select con_id, wrl_parameter, status from v\$encryption_wallet where con_id = 1;

ADMINISTER KEY MANAGEMENT ADD SECRET 'Oracle123' FOR CLIENT 'TDE_WALLET' TO LOCAL AUTO_LOGIN KEYSTORE '${TDE_SEPS_DIR}';

select con_id, wrl_parameter, status from v\$encryption_wallet where con_id = 1;
SHUTDOWN IMMEDIATE;

STARTUP;

select con_id, wrl_parameter, status from v\$encryption_wallet where con_id = 1;
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY EXTERNAL STORE;
select con_id, wrl_parameter, status from v\$encryption_wallet where con_id = 1;

ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY EXTERNAL STORE with backup;
select con_id, wrl_parameter, status from v\$encryption_wallet where con_id = 1;

ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE '${TDE_WALLET_DIR}' IDENTIFIED BY Oracle123;

select con_id, wrl_parameter, status from v\$encryption_wallet where con_id = 1;
connect / as syskm

ALTER DATABASE DICTIONARY ENCRYPT CREDENTIALS;

EOF



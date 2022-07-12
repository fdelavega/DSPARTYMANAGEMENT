#!/bin/bash

MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3333"
MYSQL_PARTY_DB="DSPARTYMANAGEMENT"

MYSQL_USER="root"
MYSQL_PASSWD="my-secret-pw"


echo "mysqldump -u ${MYSQL_USER} –-password -h ${MYSQL_HOST} -P ${MYSQL_PORT} ${MYSQL_PARTY_DB} > partydump.sql"

#docker exec -ti 3a7d67c29918 mysqldump -u ${MYSQL_USER} –-password -h ${MYSQL_HOST} -P ${MYSQL_PORT} ${MYSQL_PARTY_DB} > partydump.sql

# Generate dump of current database
echo "Creating database dump"
mysqldump -u ${MYSQL_USER} --password -h ${MYSQL_HOST} -P ${MYSQL_PORT} --column-statistics=0 ${MYSQL_PARTY_DB} > partydump.sql
# mysqldump -u root --password -h 127.0.0.1 -P 3333 -v --column-statistics=0 DSPARTYMANAGEMENT > partydump.sql

# Generate new dump to be loaded
cp partydump.sql newpartydump.sql

# Apply changes
#ALTER TABLE ORGANIZATION DROP FOREIGN KEY FK_ORGANIZATION_CHARACTERISTIC_ORGANIZATION__0;
sed -i '' '/`FK_ORGANIZATION_CHARACTERISTIC_ORGANIZATION__0`.*/d' newpartydump.sql 

#ALTER TABLE ORGANIZATION DROP COLUMN CHARACTERISTIC_ORGANIZATION__0;
sed -i '' '/`CHARACTERISTIC_ORGANIZATION__0`.*/d' newpartydump.sql

#ALTER TABLE CHARACTERISTIC ADD CHARACTERISTIC_ORGANIZATION_ID varchar(255) DEFAULT NULL;
#ALTER TABLE CHARACTERISTIC ADD CONSTRAINT FK_CHARACTERISTIC_CHARACTERISTIC_ORGANIZATION_ID FOREIGN KEY (CHARACTERISTIC_ORGANIZATION_ID) REFERENCES ORGANIZATION(ID);

sed -i '' 's/.*`CHARACTERISTIC_INDIVIDUAL_ID` varchar(255) DEFAULT NULL,.*/`CHARACTERISTIC_INDIVIDUAL_ID` varchar(255) DEFAULT NULL, \n `CHARACTERISTIC_ORGANIZATION_ID` varchar(255) DEFAULT NULL,/g' newpartydump.sql
sed -i '' 's/.*KEY `FK_CHARACTERISTIC_CHARACTERISTIC_INDIVIDUAL_ID` (`CHARACTERISTIC_INDIVIDUAL_ID`),.*/KEY `FK_CHARACTERISTIC_CHARACTERISTIC_INDIVIDUAL_ID` (`CHARACTERISTIC_INDIVIDUAL_ID`), \n KEY `FK_CHARACTERISTIC_CHARACTERISTIC_ORGANIZATION_ID` (`CHARACTERISTIC_ORGANIZATION_ID`),/g' newpartydump.sql
sed -i '' 's/.*CONSTRAINT `FK_CHARACTERISTIC_CHARACTERISTIC_INDIVIDUAL_ID` FOREIGN KEY (`CHARACTERISTIC_INDIVIDUAL_ID`) REFERENCES `INDIVIDUAL` (`ID`).*/CONSTRAINT `FK_CHARACTERISTIC_CHARACTERISTIC_INDIVIDUAL_ID` FOREIGN KEY (`CHARACTERISTIC_INDIVIDUAL_ID`) REFERENCES `INDIVIDUAL` (`ID`), \n CONSTRAINT `FK_CHARACTERISTIC_CHARACTERISTIC_ORGANIZATION_ID` FOREIGN KEY (`CHARACTERISTIC_ORGANIZATION_ID`) REFERENCES `ORGANIZATION` (`ID`)/g' newpartydump.sql


# Update values (remove the null as characteristics were not used)
sed -i '' '/INSERT INTO `ORGANIZATION`/ s/NULL,NULL)/NULL)/g' newpartydump.sql

# Load the dump
echo "Droping old database"
mysql -u ${MYSQL_USER} --password -h ${MYSQL_HOST} -P ${MYSQL_PORT} -e "DROP DATABASE ${MYSQL_PARTY_DB};"

echo "Creating new database"
mysql -u ${MYSQL_USER} --password -h ${MYSQL_HOST} -P ${MYSQL_PORT} -e "CREATE DATABASE ${MYSQL_PARTY_DB};"

echo "Loading updated dump"
mysql -u ${MYSQL_USER} --password -h ${MYSQL_HOST} -P ${MYSQL_PORT} ${MYSQL_PARTY_DB} < newpartydump.sql
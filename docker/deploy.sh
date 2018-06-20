#!/bin/bash

# Compile sources
cd /party
mvn install

# Create database if needed
MYSQL_HOST=mysql.docker
MYSQL_ROOT_PASSWORD=toor
MYSQL_URL="jdbc\:mysql\://${MYSQL_HOST}\:3306/DSPARTYMANAGEMENT"

mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h ${MYSQL_HOST} -e "CREATE DATABASE IF NOT EXISTS DSPARTYMANAGEMENT;"

# Create database jdbc conection and deploy the war

export PATH=$PATH:/glassfish4/glassfish/bin
asadmin stop-domain
asadmin start-domain --debug

asadmin create-jdbc-connection-pool --restype java.sql.Driver --driverclassname com.mysql.jdbc.Driver --property user=root:password=${MYSQL_ROOT_PASSWORD}:URL=${MYSQL_URL} DSPARTYMANAGEMENT

asadmin create-jdbc-resource --connectionpoolid DSPARTYMANAGEMENT jdbc/partydb

asadmin deploy --force true --contextroot DSPartyManagement --name DSPartyManagement /party/target/DSPartyManagement.war

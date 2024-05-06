@echo off

echo Start Server 1
start mongod --config .\pisid_s1.conf
timeout /t 5 /nobreak

echo Start Server 2
start mongod --config .\pisid_s2.conf
timeout /t 5 /nobreak

echo Start Server 3
start mongod --config .\pisid_s3.conf
timeout /t 5 /nobreak

:: Wait for startup
timeout /t 5 /nobreak

:: Check status of servers
mongosh --port 27019 --eval "rs.status()"

:: Connect to mongosh and initiate replica set
mongosh --port 27019 --eval "rs.initiate()"
mongosh --port 27019 --eval "rs.add('localhost:27017')"
mongosh --port 27019 --eval "rs.add('localhost:27018')"

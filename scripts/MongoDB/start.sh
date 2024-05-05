#!/bin/sh

echo "Start Server 1"
mongod --config ./pisid_s1.conf &
PID1=$!

echo "Start Server 2"
mongod --config ./pisid_s2.conf &
PID2=$!

echo "Start Server 3"
mongod --config ./pisid_s3.conf &
PID3=$!

#Wait for startup
sleep 5

#Check status of servers
mongosh --port 27019 --eval "rs.status()"

#Connect to mongosh 
mongosh --port 27019 --eval "rs.initiate()"
mongosh --port 27019 --eval "rs.add('localhost:27017')"
mongosh --port 27019 --eval "rs.add('localhost:27018')"
exit

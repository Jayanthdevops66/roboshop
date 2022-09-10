source common.sh

COMPONENT=mongodb

echo Setup Yum Repos
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
StatusCheck

echo install mongodb
yum install -y mongodb-org &>>${LOG}
StatusCheck

echo Start MongoDB service
systemctl enable mongod &>>${LOG} && systemctl start mongod &>>${LOG}
StatusCheck

## Update the Listen Config
DOWNLOAD

echo "Extract Schema files"
cd /tmp && unzip -o mongodb.zip &>>${LOG}
StatusCheck

echo Load Schema
cd mongodb-main && mongo < catalogue.js &>>${LOG} && mongo < users.js &>>${LOG}
StatusCheck
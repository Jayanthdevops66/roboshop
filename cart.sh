source common.sh

COMPONENT=cart
NodeJs

echo Configuring cart SystemD Service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG}
systemctl daemon-reload &>>${LOG}
StatusCheck

echo Starting Cart Service
systemctl start cart &>>${LOG}
systemctl enable cart &>>${LOG}
StatusCheck
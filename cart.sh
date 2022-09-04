source common.sh


Nodejs


echo Downloading application content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>/tmp/cart.log
cd /home/roboshop &>>/tmp/cart.log
StatusCheck

echo Cleaning old Application Content
rm -rf cart &>>/tmp/cart.log
StatusCheck

echo Extract Appplication Content
unzip -o /tmp/cart.zip &>>/tmp/cart.log
mv cart-main cart &>>/tmp/cart.log
cd cart &>>/tmp/cart.log
StatusCheck

echo Installing Nodejs Dependencies
npm install &>>/tmp/cart.log
StatusCheck

echo Configuring cart SystemD Service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
systemctl daemon-reload &>>/tmp/cart.log
StatusCheck

echo Starting Cart Service
systemctl start cart &>>/tmp/cart.log
systemctl enable cart &>>/tmp/cart.log
StatusCheck
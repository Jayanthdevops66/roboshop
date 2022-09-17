#!/usr/bin/bash

# Roboshop - Frontend Setup

source common.sh

COMPONENT=frontend

echo installing nginx
yum install nginx -y &>>${LOG}
StatusCheck

echo Downloading frontend application content
DOWNLOAD

echo Cleaning Old Content
cd /usr/share/nginx/html && rm -rf *
StatusCheck

echo Extract Downloaded Content
unzip -o /tmp/frontend.zip &>>${LOG} && mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
StatusCheck

echo Updating Nginx Configuration
sed -i -e  '/catalogue/ s/localhost/catalogue-dev.roboshop.internal/' -e '/cart/ s/localhost/cart-dev.roboshop.internal/' -e '/user/ s/localhost/user-dev.roboshop.internal/' -e '/payment/ s/localhost/payment-dev.roboshop.internal/' -e '/shipping/ s/localhost/shipping-dev.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
StatusCheck


echo restarting nginx service
systemctl restart nginx &>>${LOG} && systemctl enable nginx &>>${LOG}
StatusCheck
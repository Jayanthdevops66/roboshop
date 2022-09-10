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

echo restarting nginx service

systemctl restart nginx &>>${LOG} && systemctl enable nginx &>>${LOG}
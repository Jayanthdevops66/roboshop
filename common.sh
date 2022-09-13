StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mSUCCESS\e[0m"
    exit 1
  fi
}
DOWNLOAD() {
  echo Downloading ${COMPONENT} application content
     curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
     StatusCheck
}

APP_USER_SETUP() {
  id roboshop &>>${LOG}
     if [ $? -ne 0 ]; then
       echo Adding Application user
       useradd roboshop &>>${LOG}
       StatusCheck
     fi
}
APP_CLEAN() {
   echo Cleaning old Application Content
     cd /home/roboshop &>>${LOG} && rm -rf ${COMPONENT} &>>${LOG}
     StatusCheck

     echo Extract Appplication Content
     unzip -o /tmp/${COMPONENT}.zip &>>${LOG} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG} && cd ${COMPONENT} &>>${LOG}
     StatusCheck
}
SYSTEMD() {
  echo Configuring ${COMPONENT} SystemD Service
     mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG}
     systemctl daemon-reload &>>${LOG}
     StatusCheck

     echo Starting ${COMPONENT} Service
     systemctl start ${COMPONENT} &>>${LOG} && systemctl enable ${COMPONENT} &>>${LOG}
     StatusCheck
}

 NodeJs() {
   echo Setting nodejs repos
   curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
   StatusCheck

   echo Installing nodejs
   yum install nodejs -y &>>${LOG}
   StatusCheck

   APP_USER_SETUP
   DOWNLOAD

   APP_CLEAN
   echo Installing Nodejs Dependencies
   npm install &>>${LOG}
   StatusCheck

   SYSTEMD
 }
JAVA() {
  echo Install Maven
  yum install maven -y &>>${LOG}
  StatusCheck

  APP_USER_SETUP
  DOWNLOAD

  APP_CLEAN

  echo Make application package
  mvn clean package &>>${LOG} && mv target/shipping-1.0.jar shipping.jar &>>${LOG}
  StatusCheck

  SYSTEMD

}

PYTHON() {
  echo Install Python
  yum install python36 gcc python3-devel -y &>>${LOG}
  StatusCheck

  APP_USER_SETUP
  DOWNLOAD

  APP_CLEAN


  echo Install Python Dependencies
  cd /home/roboshop/payment && pip3 install -r requirements.txt &>>${LOG}
  StatusCheck

  SYSTEMD
}
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m you should run this script as a root user or sudo\e[0m"
  exit 1
fi

LOG=/tmp/${COMPONENT}.log
rm -f ${LOG}
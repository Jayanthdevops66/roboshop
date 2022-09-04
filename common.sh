StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mSUCCESS\e[0m"
    exit 1
  fi
}
 NodeJs() {
   echo Setting nodejs repos
   curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/$(COMPONENT).log
   StatusCheck

   echo Installing nodejs
   yum install nodejs -y &>>/tmp/$(COMPONENT).log
   StatusCheck

   id roboshop &>>/tmp/$(COMPONENT).log
   if [ $? -ne 0 ]; then
     echo Adding Application user
     useradd roboshop &>>/tmp/$(COMPONENT).log
     StatusCheck
   fi
   echo Downloading application content
   curl -s -L -o /tmp/$(COMPONENT).zip "https://github.com/roboshop-devops-project/$(COMPONENT)/archive/main.zip" &>>/tmp/$(COMPONENT).log
   cd /home/roboshop &>>/tmp/$(COMPONENT).log
   StatusCheck

   echo Cleaning old Application Content
   rm -rf $(COMPONENT) &>>/tmp/$(COMPONENT).log
   StatusCheck

   echo Extract Appplication Content
   unzip -o /tmp/$(COMPONENT).zip &>>/tmp/$(COMPONENT).log
   mv $(COMPONENT)-main $(COMPONENT) &>>/tmp/$(COMPONENT).log
   cd $(COMPONENT) &>>/tmp/$(COMPONENT).log
   StatusCheck

   echo Installing Nodejs Dependencies
   npm install &>>/tmp/$(COMPONENT).log
   StatusCheck
 }
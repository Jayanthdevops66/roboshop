source common.sh
COMPONENT=mysql

echo Setup Yum Repos
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
StatusCheck

echo Install MySql
yum install mysql-community-server -y &>>${LOG}
StatusCheck

echo Start MySql service
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}

DEFAULT_PASSWORD=$(grep "A tem" /var/log/mysqld.log | awk '{print $NF}')
echo "alter use 'root'@'localhost' identified with mysql_native_password by 'RoboShop@1';" | mysql -uroot -p${DEFAULT_PASSWORD}

mysql_secure_installation

mysql -uroot -pRoboShop@1
#> uninstall plugin validate_password;

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

cd /tmp
unzip -o mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql

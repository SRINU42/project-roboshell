source common.sh

echo -e "${color} disable MySQL 8 version. ${nocolor}"
dnf module disable mysql -y &>>${log_file}

echo -e "${color} Setup the MySQL5.7 repo file ${nocolor}"
cp /home/centos/project-roboshell/mysql.repo /etc/yum.repos.d/mmysql.repo &>>${log_file}

echo -e "${color} Install MySQL Server${nocolor}"
dnf install mysql-community-server -y &>>${log_file}

echo -e "${color} StartMYSQL services ${nocolor}"
systemctl enable mysqld
systemctl restart mysqld  

echo -e "${color} Setup MYSQL password  ${nocolor}"
mysql_secure_installation --set-root-pass RoboShop@1

echo -e "${color} set password ${nocolor}"
mysql -uroot -pRoboShop@1




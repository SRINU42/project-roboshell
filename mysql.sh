source common.sh

echo -e "${color} disable MySQL 8 version. ${nocolor}"
dnf module disable mysql -y &>>${log_file}
stat_check $?

echo -e "${color} Setup the MySQL5.7 repo file ${nocolor}"
cp /home/centos/project-roboshell/mysql.repo /etc/yum.repos.d/mmysql.repo &>>${log_file}
stat_check $?

echo -e "${color} Install MySQL Server${nocolor}"
dnf install mysql-community-server -y &>>${log_file}
stat_check $?

echo -e "${color} StartMYSQL services ${nocolor}"
systemctl enable mysqld
systemctl restart mysqld  
stat_check $?

echo -e "${color} Setup MYSQL password  ${nocolor}"
mysql_secure_installation --set-root-pass $1
stat_check $?

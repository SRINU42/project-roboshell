echo -e "\e[35m Setup the MongoDB repo file  \e[0m"
cp /home/centos/project-roboshell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "\e[35m instal Mongodb  \e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\e[35m Update listen address \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>/tmp/roboshop.log

echo -e "\e[35m Enable mongodb SystemD  \e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl start mongod &>>/tmp/roboshop.log


source common.sh

echo -e "${color} Setup the MongoDB repo file  ${nocolor}"
cp /home/centos/project-roboshell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

echo -e "${color} instal Mongodb  ${nocolor}"
dnf install mongodb-org -y &>>${log_file}

echo -e "${color} Update listen address ${nocolor}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

echo -e "${color} Enable mongodb SystemD  ${nocolor}"
systemctl enable mongod &>>${log_file}
systemctl start mongod &>>${log_file}


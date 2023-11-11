echo -e "\e[35m Setup NodeJS repos.  \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[35m Install NodeJS \e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[35m Add application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[35m Lets setup an app directory \e[0m"
rm -rf /app
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[35m Download the application \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 
cd /app 
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[35m  download the dependencies. \e[0m"
cd /app 
npm install &>>/tmp/roboshop.log

echo -e "\e[35m Setup SystemD Catalogue Service \e[0m"
cp /home/centos/project-roboshell/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[35m Load the service start the services \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log

echo -e "\e[35m setup MongoDB repo \e[0m"
cp /home/centos/project-roboshell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "\e[35m Installing the Mongod \e[0m"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[35m Load Schema \e[0m"
mongo --host mongodb-dev.devopssessions.store </app/schema/catalogue.js &>>/tmp/roboshop.log
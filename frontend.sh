source common.sh

echo -e "${color} instal Nginx ${nocolor}"
dnf install nginx -y &>>${log_file}

echo -e "${color} remove Frontend  ${nocolor}"
rm -rf /usr/share/nginx/html/* &>>${log_file}


echo -e "${color} Dowloading frontend  ${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${log_file}


echo -e "${color}Extractin & Copy Frontend  ${nocolor}"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>${log_file}


echo -e "${color}Update Frontend Configuration ${nocolor}" 

cp  /home/centos/project-roboshell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}


echo -e "${color}Enable SystemD ${nocolor}"
systemctl enable nginx &>>${log_file}

systemctl restart nginx &>>${log_file}


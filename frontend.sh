
echo -e "\e[35m instal Nginx \e[0m"
dnf install nginx -y &>>/tmp/roboshop.log

echo -e "\e[35m remove Frontend  \e[0m"
rm -f /usr/share/nginx/html/* &>>/tmp/roboshop.log


echo -e "\e[35m Dowloading frontend  \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>/tmp/roboshop.log


echo -e "\e[35m Extractin & Copy Frontend  \e[0m"
rm -f /usr/share/nginx/html
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip 


echo -e "\e[35m Update Frontend Configuration \e[0m" 

cp  /home/centos/project-roboshell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/roboshop.log


echo -e "\e[35m Enable SystemD \e[0m"
systemctl enable nginx &>>/tmp/roboshop.log

systemctl restart nginx &>>/tmp/roboshop.log


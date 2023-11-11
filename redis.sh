source common.sh
component=redis

echo -e "${color} ${component} is offering the repo file${nocolor}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}

echo -e "${color} Enable ${component} 6.2 from package ${nocolor}"
dnf module enable ${component}:remi-6.2 -y &>>${log_file}

echo -e "${color} Install ${component} ${nocolor}"
dnf install ${component} -y &>>${log_file}

echo -e "${color} Update listen address ${nocolor}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/${component}.conf &>>${log_file}

echo -e "${color} Enable ${component} Service ${nocolor}"
systemctl enable ${component} &>>${log_file}
systemctl restart ${component} &>>${log_file} 
color="\e[33m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

systemd_setup() {

    echo -e "${color} Setup SystemD ${component} Service ${nocolor}"
    cp /home/centos/project-roboshell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}

    echo -e "${color} Load the service start the services ${nocolor}"
    systemctl daemon-reload &>>${log_file}
    systemctl enable ${component} &>>${log_file}
    systemctl restart ${component} &>>${log_file}

}

stat_check() {
    if[$?]
}
nodejs() {
    echo -e "${color} Setup NodeJS repos.  ${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

    echo -e "${color} Install NodeJS ${nocolor}"
    dnf install nodejs -y &>>${log_file}

    echo -e "${color} Add application User ${nocolor}"
    useradd roboshop &>>${log_file}

    echo -e "${color} Lets setup an app directory ${nocolor}"
    rm -rf /app
    mkdir /app &>>${log_file}

    echo -e "${color} Download the application ${nocolor}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 
    cd /app 
    unzip /tmp/${component}.zip &>>${log_file}

    echo -e "${color}  download the dependencies. ${nocolor}"
    cd /app 
    npm install &>>${log_file}



}

systemd_setup() 

mongo_schema_setup() {

    echo -e "${color} setup MongoDB repo ${nocolor}"
    cp /home/centos/project-roboshell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

    echo -e "${color} Installing the Mongod ${nocolor}"
    dnf install mongodb-org-shell -y &>>${log_file}

    echo -e "${color} Load Schema ${nocolor}"
    mongo --host mongodb-dev.devopssessions.store </app/schema/${component}.js &>>${log_file}

}


maven() {
    echo -e "${color} Install Maven ${nocolor}"
    dnf install maven -y &>>${log_file}

    echo -e "${color} add application user ${nocolor}"
    useradd roboshop &>>${log_file}

    mkdir /app &>>${log_file}

    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    cd /app &>>${log_file}
    unzip /tmp/${component}.zip &>>${log_file}

    echo -e "${color} Dowload mavan dependies ${nocolor}"
    cd /app &>>${log_file}
    mvn clean package &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>>${log_file}

    cp /home/centos/project-roboshell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}

    systemctl daemon-reload

    systemctl enable shipping 
    systemctl restart shipping

    echo -e "${color} install mysql ${nocolor}"
    dnf install mysql -y 

    echo -e "${color} set mysql password ${nocolor}"
    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql 

    echo -e "${color} install mysql ${nocolor}"
    systemctl restart shipping

}
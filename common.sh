color="\e[33m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"
if [ $user_id -ne 0 ]; then
  echo Script should be running with sudo
  exit 1
fi

stat_check() {
    if [$1 -eq 0]; then
        echo SUCCESS
    else
        echo FAILUER
        exit 1
    fi

}
systemd_setup() {

    echo -e "${color} Setup SystemD ${component} Service ${nocolor}"
    cp /home/centos/project-roboshell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    sed -i -e "s/roboshop_app_password/$roboshop_app_password" /etc/systemd/system/${component}.service &>>${log_file}
    stat_check $?

    echo -e "${color} Load the service start the services ${nocolor}"
    systemctl daemon-reload &>>${log_file}
    systemctl enable ${component} &>>${log_file}
    systemctl restart ${component} &>>${log_file}

}

app_presetup() {
    echo -e "${color} Add application User ${nocolor}"
    id roboshop &>>$log_file
    if [ $? -eq 1]; then 
    useradd roboshop &>>${log_file}
    stat_check $?

    echo -e "${color} Lets setup an app directory ${nocolor}"
    rm -rf /app
    mkdir /app &>>${log_file}
    stat_check $?

    echo -e "${color} Download the application ${nocolor}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 
    cd /app 
    unzip /tmp/${component}.zip &>>${log_file}
    stat_check $?
    
}
nodejs() {
    echo -e "${color} Setup NodeJS repos.  ${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
    stat_check $?

    echo -e "${color} Install NodeJS ${nocolor}"
    dnf install nodejs -y &>>${log_file}
    stat_check $?
    app_presetup
    

    echo -e "${color}  download the dependencies. ${nocolor}"
    cd /app 
    npm install &>>${log_file}
    stat_check $?

    systemd_setup


}


mongo_schema_setup() {

    echo -e "${color} setup MongoDB repo ${nocolor}"
    cp /home/centos/project-roboshell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    stat_check $?

    echo -e "${color} Installing the Mongod ${nocolor}"
    dnf install mongodb-org-shell -y &>>${log_file}
    stat_check $?

    echo -e "${color} Load Schema ${nocolor}"
    mongo --host mongodb-dev.devopssessions.store </app/schema/${component}.js &>>${log_file}
    stat_check $?

}

mysql_schema_setup() {
    echo -e "${color} install mysql ${nocolor}"
    dnf install mysql -y 
    stat_check $?

    echo -e "${color} set mysql password ${nocolor}"
    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${mysql_root_password} < /app/schema/shipping.sql 
    stat_check $?

}


maven() {
    echo -e "${color} Install Maven ${nocolor}"
    dnf install maven -y &>>${log_file}
    stat_check $?

    app_presetup

    echo -e "${color} Dowload mavan dependies ${nocolor}"
    cd /app &>>${log_file}
    mvn clean package &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
    stat_check $?

    mysql_schema_setup

    systemd_setup

}

python() {

    echo -e "${color} Install Python 3.6   ${nocolor}"
    dnf install python36 gcc python3-devel -y &>>${log_file}
    stat_check $?

    app_presetup

    echo -e "${color} download the dependencies.  ${nocolor}"
    cd /app 
    pip3.6 install -r requirements.txt &>>${log_file}
    stat_check $?

    systemd_setup
}
golang() {
    echo -e "${color} Install GoLang ${nocolor}"
    dnf install golang -y &>>${log_file}
    stat_check $?

    app_presetup

    echo -e "${color} Lets download the dependencies ${nocolor}"
    cd /app 
    go mod init ${component} &>>${log_file}
    go get &>>${log_file}
    go build &>>${log_file}
    stat_check $?

    systemd_setup
    
}
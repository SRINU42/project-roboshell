source common.sh

echo -e "${color} Configure YUM Repos   ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
stat_check $?

echo -e "${color} Configure YUM Repos for RabbitMQ.  ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
stat_check $?

echo -e "${color} Install RabbitMQ  ${nocolor}"
dnf install rabbitmq-server -y &>>${log_file}
stat_check $?

echo -e "${color} Start RabbitMQ Service  ${nocolor}"
systemctl enable rabbitmq-server &>>${log_file}
systemctl restart rabbitmq-server &>>${log_file}
stat_check $?

echo -e "${color}  default username / password ${nocolor}"
rabbitmqctl add_user roboshop $1 &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
stat_check $?


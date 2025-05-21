#!/bin/bash
#
#yum install ansible python3.12-pip -y &>>/opt/userdata.log
#pip3.12 install botocore boto3 &>>/opt/userdata.log
#ansible-pull -i localhost, -U https://github.com/Tejaswini-Devops/expense-ansible.git expense.yml -e service_name="${service_name}" -e env="${env}" &>>/opt/userdata.log



LOG_FILE="/opt/userdata.log"

# Install Ansible and Python 3.12 pip
dnf install -y ansible python3.12 python3.12-pip &>>$LOG_FILE

# Install AWS SDK libraries for Ansible to use
/usr/bin/python3.12 -m pip install boto3 botocore &>>$LOG_FILE

# Use correct Python interpreter with ansible-pull
ansible-pull -i "localhost ansible_python_interpreter=/usr/bin/python3.12" \
  -U https://github.com/Tejaswini-Devops/expense-ansible.git \
  expense.yml \
  -e service_name="${service_name}" \
  -e env="${env}" &>>$LOG_FILE

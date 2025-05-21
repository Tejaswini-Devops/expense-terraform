#!/bin/bash

yum install -y ansible python3.11 python3.11-pip &>>/opt/userdata.log
/usr/bin/python3.11 -m pip install boto3 botocore &>>/opt/userdata.log

ansible-pull -i "localhost ansible_python_interpreter=/usr/bin/python3.11," \
  -U https://github.com/Tejaswini-Devops/expense-ansible \
  expense.yml \
  -e service_name=${service_name} \
  -e env=${env} &>>/opt/userdata.log

#!/bin/bash

yum install ansible python3.12-pip -y &>>/opt/userdata.log
pip3.12 install botocore boto3 &>>/opt/userdata.log
ansible-pull -i localhost, -U https://github.com/Tejaswini-Devops/expense-ansible.git expense.yml -e service_name="${service_name}" -e env="${env}" &>>/opt/userdata.log
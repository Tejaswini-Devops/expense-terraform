#!/bin/bash

# Install Ansible and pip for Python 3.12
dnf install -y ansible python3.12-pip &>>/opt/userdata.log

# Use pip for Python 3.12 explicitly
/usr/bin/pip3.12 install boto3 botocore &>>/opt/userdata.log

# Optional: Ensure ansible uses Python 3.12
export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.12

ansible-pull -i localhost, -U https://github.com/Tejaswini-Devops/expense-ansible expense.yml -e service_name=${service_name} -e env=${env} &>>/opt/userdata.log